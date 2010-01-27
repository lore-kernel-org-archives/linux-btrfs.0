From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: file/extent checksums for dedup/sync...
Date: Wed, 27 Jan 2010 12:10:50 +0000
Message-ID: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For purposes of data deduplication and data synchronisation, it would
be a powerful tool to expose file data checksums.

Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
the file's overall CRC from the accumulation of the CRCs from all it's
extents' CRCs.

For now, exposing this via an IOCTL may be sufficient, though any
ideas for introducing it in a more standard way? (it's a pity that
when stat64 was introduced, reserved fields weren't added)

Thanks,
  Daniel

[1] http://www.research.ibm.com/haifa/satran/ips/Vince-Luben-crc32c-01.pdf
-- 
Daniel J Blueman
