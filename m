From: Roland Dreier <rdreier@cisco.com>
Subject: Re: btrfs fallocate woes
Date: Thu, 14 Jan 2010 09:27:38 -0800
Message-ID: <aday6k0lhpx.fsf@roland-alpha.cisco.com>
References: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Paul Komkoff <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <715ea5c11001140328g6198447axce1ba884a6e6fb96@mail.gmail.com>
	(Paul Komkoff's message of "Thu, 14 Jan 2010 11:28:39 +0000")
List-ID: <linux-btrfs.vger.kernel.org>


 > if you run it on ext4, it will create a 4-byte file with "test" in it.
 > On btrfs, however, the file size would be 4096, and the remaining
 > space will be filled with zeroes.

My fallocate man page says:

       Because allocation is done in block size chunks, fallocate() may
       allocate a larger range than that which was specified.

so the btrfs behavior seems OK to me.

You say this is a regression.  What btrfs version behaved differently?

 - R.
