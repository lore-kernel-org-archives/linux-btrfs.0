Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794760654;
	b=hmy+JulMD3TyEvOJq1vUbg8xfsRKfI0ubub+PzuvQhcAscJvUJljUGl8O96ZqbctemQI
	 B6YdObSzYCjzDpE+vnzhxDCN0JRyc6Iq0xJYdtqGpzHpeBPdToxJBzPA6CY1emZT86LV0
	 oywSDFyzJGGGs4RutkCiB5O8TnWc8GAHpNsmkKtougOd910XIr0oBwvVgnvsDEhAL8yzF
	 xP1hihvj6VSIF+c7Rr/4lgzX9qx+heCeu2K6HgDQ+wqV0LFUUzQuB6blRMlC1S3Oaevxl
	 YiB8U/rPbIwTl6ceRXBfa0nryY13xyGsa/WPNlg3VW7UE2+yFoLD54E1DxGQP0CEiqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794760654;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=dlc8V/OOB/QQSWru42A5t6SnexLXK3CKb+t63ASV9wU=;
	b=bYqmyDsdaMokIfw0XOBmFn3WxEqRGHLIiVKPral35BkJUYcH8FBNFFSC9RJqFEe/7vDn
	 9WSKMlW0bJi7CwIld/4sSmotwxM1XEDt5zCfHuEe/ofLT5jE/rLMoXPldfZ5hvIr0Uimj
	 p90wVB63MqosyUt99JFXskEu3nwah+IVN0/2F2oPc3JDyvIk7rOW+Hsip/R1LoM7w2vvZ
	 NG8f+2OOMzZSF1/JU2Lgb/8925H3odKbUktWGBDXz6+3IJ1PakW1naN+xLDFSRZN2goA4
	 Os56VkkJ33P5PrkK2vekO0LqnrkdObsjhDDxwOuioeTxb0u9904ArC8aOqI08Kwp8Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tp2W7hcO;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715C3606A31E
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 16:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 715C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tp2W7hcO
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37986eb6fa2so2940185eec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 08:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794760654; x=1795365454; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dlc8V/OOB/QQSWru42A5t6SnexLXK3CKb+t63ASV9wU=;
        b=Tp2W7hcOhv5cQ0psdzWW/uwVX1iuSTEd8Ak1Lgec5yLNuRjNWH+a2jbeFWflA+x7mD
         yxI4eLhsyhSlsVwO2L4MHdUNNrKj4T/lIbEmrFK/Lz7W/DzbRPj6sDqVbDmRciOxfF/3
         rY79RjFmpv02qOH8+pYclbn7u6OnGvSaP6NwOxCOnCkoEoWqSkQYsIQHFDTBahBqdpBe
         I2wPWD/7vHuuSjlDt1tsMoLnLe0szQn04JqXgCYTpD8kveTvHC/gG29khdWlhEl6AZHZ
         scBG5wyBUhXY0SVDhWbI8DFP+/yl3eunIqrey3iwjGsx30iJvtVCrBsqfUDGdDpG7U23
         xceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794760654; x=1795365454;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dlc8V/OOB/QQSWru42A5t6SnexLXK3CKb+t63ASV9wU=;
        b=SeW0hIKCHqBRiRfH7h88z4HnY6Y3rpZUt+maw2vC7IFBs7ooW7QGjM0Rtg/Z5jkjD7
         /L/xWKHbgd497XpgvXVi9LpgQUg0+ntrgeX/FdhhHth3IhWg/x5udn9zGuYhZcdf8wAF
         4LffY1b2QQo1lyFmU3loIfEGmLDb4hlra0jng51xhoe2toO+IpGCTMiFiInZ05We3UJ4
         bUrbt59YdmPJBGgqvI6gj5To6TuXyXRT4VM3ULtHLwal09kVEe0YgQleROYIeAvuBFPM
         mPCeXDYM1zg0WMFP5LleTSLPqAMmsWKoIKCUaP4suly6Nn4sl8MHaW2gbI4EMiPinoYl
         4lNw==
X-Forwarded-Encrypted: i=1; AL+hErG11YUcDnImuQs4WcxsJjmVL+rkVm3RAAv2pgGrxroL9lodxnJocP2ThrCTjLbphaC1mxH81qJKtCGiHQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8mA5dmXy7AaRM17Nx2U1d2paBfqGLyNUjuM76SgNkPtvu1moqu
	zI2byw0xwR/SEM2LmjCZRFoysBLk40Td3hWNv8N7Z2aGz5S3LbR3IPLWcxtzjVZBlDU=
X-Gm-Gg: AYBFou0f2YSAKKdNizBDAZRukSLFq1VxlPI/YpIf4Q8l3Ls/QKOewn1xpLA4HD27fnd
	t60E5OB7U4mICSVqqwAGgnX2Qtgw+kmt07qfAifb7kvUtnh8QCEKQnXNXDOWIdneJxTz9h+JWhV
	No1Dh7jbgxE+PYF0b6n7atp9QOpO99BNFp/eIGVMfFkihSIjm0M/l6UfGue1XtuJ8Vv9yZvZyVF
	a8XGhQVbFPr0/iGk/u63cCsdcyzWYkK0ENk4ysw/jW66w/bRU1NXd2xcSUPMozG6DeWRsYwwESy
	n8BslWy9NLCiqemZ6LAPYMGmgFYxEiyNAC9lys866zxOAPLazK4Q9vNiwOXUkIV8Ig+Gv6IpUtt
	TIQ6zzhoun+m5ajlIH7rZwC1rvFoxx6h3u0UWVUD7l2CcdHcBSmgXs8ArzDb7OYblt5z/3BjQ96
	XTMHHNZgq9m4OHRZoe8uFxrhK5UIa5rYV70ThKFUj7Q7XfHESVYGAI03bB90Ue0q+hnwKPKB3MJ
	o3Em9twQsfS1ltLBMcv1Ewm0c5ZahaK+VifbpENEQjQ8u60wCGHQ1bIpv8dNxHBET9wJWM9cYyd
	Cp69ENTFB0lF8c04okH217Ld87xQX0AEchQ5n8LO1huCRdywYptmqIHcEAxsZLt0xI2M
X-Received: by 2002:a05:7300:c8c5:b0:379:e0a2:1a1 with SMTP id 5a478bee46e88-379e0a20687mr7936822eec.35.1794760653398;
        Sun, 15 Nov 2026 08:37:33 -0800 (PST)
Received: from youngkk-vm.localdomain (67.216.200.102.16clouds.com. [67.216.200.102])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795378d7e5sm26204965eec.3.2026.11.15.08.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 08:37:32 -0800 (PST)
From: Cheng Yongkang <teel4res@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] btrfs: oversized compressed disk_num_bytes is not rejected
Date: Sun, 15 Nov 2026 08:37:23 -0800
Message-Id: <20261115163724.226922-1-teel4res@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi David,

I hit a corner case with crafted images. It needs a compressed file
extent whose disk_num_bytes is far above what btrfs ever writes, so it
may not matter much in practice. I found two consequences of the same
missing check.

check_extent_data_item() only checks that disk_num_bytes is sector
aligned, and the zlib read path does not limit its input to
BTRFS_MAX_COMPRESSED the way lzo_decompress_bio() does. Both cases
below are on v7.3.

1) disk_num_bytes == 0x100000000

After mounting with rescue=all and reading the file,
btrfs_submit_compressed_read() stores em->disk_num_bytes in an
unsigned int compressed_len, which becomes 0. No folio is added, and
the zero-length bio hits the assertion in btrfs_submit_bbio() (seen
with CONFIG_BTRFS_ASSERT=y):

  assertion failed: IS_ALIGNED(logical, blocksize) &&
  IS_ALIGNED(length, blocksize) && length != 0, in fs/btrfs/bio.c:895
  (root=5 inode=257 logical=9437184 length=0)
  kernel BUG at fs/btrfs/bio.c:895!
   btrfs_submit_compressed_read
   btrfs_readahead

2) zlib extent with disk_num_bytes == 4 MiB

With num_bytes == ram_bytes == 0x100002000 and a zlib stream that
inflates to about 4.3 GB, reading the page at file offset 0xFFFFF000
makes bvec_offset + bv_len wrap to 0 in the u32 arithmetic of
btrfs_decompress_buf2page(). copy_len is then computed from the
wrapped value, and memcpy() reads past the 4 KiB zlib workspace
buffer:

  BUG: KASAN: slab-out-of-bounds in btrfs_decompress_buf2page+0x3e0/0x650
  Read of size 4096 at addr ffff8881114049f8 by task kworker/u8:2/41
   __asan_memcpy
   btrfs_decompress_buf2page
   zlib_decompress_bio
   end_bbio_compressed_read
   btrfs_check_read_bio
  Allocated by task 9375:
   zlib_alloc_workspace
  The buggy address is located 2552 bytes inside of
   allocated 4096-byte region [ffff888111404000, ffff888111405000)

The 4 MiB compressed bio only fit into its 32 vecs when the pages were
physically contiguous, so before reading I filled 16 pipes with 1 MiB
each. Without that the read failed with -EIO or SIGBUS instead.

Both paths are unchanged in next-20261113. zstd no longer calls
btrfs_decompress_buf2page() there, but zlib and lzo still do.

Compression and encoded writes never create a compressed extent larger
than BTRFS_MAX_COMPRESSED, so the tree checker could reject such an
extent for all compression types, which stops both cases:

  +	if (unlikely(btrfs_file_extent_compression(leaf, fi) != BTRFS_COMPRESS_NONE &&
  +		     btrfs_file_extent_disk_num_bytes(leaf, fi) > BTRFS_MAX_COMPRESSED)) {
  +		file_extent_err(leaf, slot,
  +	"invalid disk_num_bytes for compressed file extent, have %llu expect <= %u",
  +				btrfs_file_extent_disk_num_bytes(leaf, fi),
  +				BTRFS_MAX_COMPRESSED);
  +		return -EUCLEAN;
  +	}

With this change the tree checker reports the leaf of the first image
as corrupt and the mount fails with -EIO, and normal zstd, zlib and
lzo files still read back correctly. I have not run the second image
on it; its disk_num_bytes is 4 MiB, above the limit. Separately, the
u32 arithmetic in btrfs_decompress_buf2page() could be done in u64 as
hardening. I can send patches if you want them.

Thanks,
Cheng Yongkang
