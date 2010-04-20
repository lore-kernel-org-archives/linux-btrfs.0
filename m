From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Restoring BTRFS partition
Date: Tue, 20 Apr 2010 16:30:17 -0400
Message-ID: <20100420203017.GA4532@lelouch.nomadic.ncsu.edu>
References: <w2y8c113a261004200756ucfa2eeabk617da0fc90d6ed8a@mail.gmail.com>
 <20100420155538.GB3634@laptop.oracle.com>
 <20100420165049.GA6352@flcl.lan>
 <r2x8c113a261004201014v71b6bf3dy9535bb9ac2035d6e@mail.gmail.com>
 <r2o8c113a261004201113gf771574eu35db1b0d916cdfd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Alli Quaknaa <alquaknaa@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <r2o8c113a261004201113gf771574eu35db1b0d916cdfd8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 20, 2010 at 06:13:41PM +0000, Alli Quaknaa wrote:
> So here are first ~12M of the partition. There was some junk preceding
> what is in the file, but it mostly looked like my swap or something
> (cached css, javascript and webpages I've recently visited - though I
> hope the beginning of the partition isn't somewhere else. Hopefuly you
> would be able to tell from the dump).
> 
> http://pub.yweb.cz/sda7_head.dump

The superblock in that file (starting at byte 0x10) is actually a mirror
of the real superblock. Aside from the real superblock at 0x10000,
Btrfs stores mirror copies of the superblock at 0x4000000 (64 MiB),
0x4000000000 (256 GiB), and 0x4000000000000 (1 PiB). Each superblock has
a field that indicates where it is; when you made your image, you put
the mirror superblock where the real superblock was supposed to be, and
btrfs refused to mount it because that field was wrong. 

The real start of the btrfs partition is 0x4000000 bytes (64 MiB) before
the place you found that mirror superblock; the real superblock should
be 0x3ff0000 bytes before the mirror. Even if the real superblock is
corrupt, if the mirror is at 0x4000000, where it's supposed to be, you
should be able to get btrfs to mount it (though I think you might need a
mount option or a patch).
