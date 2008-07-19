From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: single disk reed solomon codes
Date: Sat, 19 Jul 2008 09:50:04 -0700
Message-ID: <1216486204.2475.11.camel@shinybook.infradead.org>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-07-19 at 15:21 +0300, Ahmed Kamal wrote:
> Hi,
> Since btrfs is someday going to be the default FS for Linux, and will
> be on so many single disk PCs and laptops, I was thinking it should be
> a good idea to insert some redundancy in single disk deployments. Of
> course it can help with disk failures, since it's obviously a "single"
> disk, but it can help with bit-rot, and with hardware sector read
> errors. To get that we'd need to implement some kind of forward error
> correction, possibly reed solomon code. I am not sure why no
> filesystem seems to implement such scheme, although I believe at the
> hardware level, such schemes are being used (so the idea is
> applicable) ?

We have implementations of such schemes in lib/reed_solomon/ in the
kernel already.

I'm quite interested in using btrfs on flash (I mean  _real_ flash not
SSDs where they have their own internal pseudo-fs pretending to be a
disk). For that, we'd probably want to use precisely this kind of error
correction. Although it's normal to do it at the block level rather than
the filesystem object level;

I don't know if the failure modes on real disks are likely to be helped
by this kind of scheme or not. After all, the disks already do a similar
RS-based error correction for themselves. If we're unlucky in our choice
of error correction, it might even be possible to end up in a situation
where the only errors we'd _see_ are the ones which were uncorrectable.

-- 
dwmw2

