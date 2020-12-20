function xrec = StDecompressor(BITS,HUFFVAL,scodrec)
    
    [~, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
    [MINCODE, MAXCODE, VALPTR] = HDecodingTables(BITS, HUFFCODE);
    xrec = DecodeString(scodrec, MINCODE, MAXCODE, VALPTR, HUFFVAL);

end

