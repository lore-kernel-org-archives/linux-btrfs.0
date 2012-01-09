From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Mon, 9 Jan 2012 15:44:18 +0200
Message-ID: <20120109134418.GA10425@zambezi.lan>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
 <CAAdM645+sZ-z1T5==M9S_GBJ1R2h=8fwtx57uvXxWkFR=VtReg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAdM645+sZ-z1T5==M9S_GBJ1R2h=8fwtx57uvXxWkFR=VtReg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2012 at 01:50:34AM -0500, Marios Titas wrote:
> I tried this for many different scenarios and it seems to work pretty
> well. I only ran into one problematic case: If you remove a device
> from a multidevice filesystem it crashes. Here's how to reproduce it:
> 
> truncate -s1g /tmp/test1
> truncate -s1g /tmp/test2
> losetup /dev/loop1 /tmp/test1
> losetup /dev/loop2 /tmp/test2
> mkdir /tmp/test
> ./mkfs.btrfs -L test -d single -m single /dev/loop1 /dev/loop2
> mount -o noatime /dev/loop1 /tmp/test
> ./btrfs dev del /dev/loop1 /tmp/test
> ./btrfs fi bal start /tmp/test
> 
> There is no actual restriping involved but the above example does work
> corretly under 3.1+for-linus whereas it fails with your patches.

Thanks for your testing.  The good news is that I put that BUG() there
simply for debugging so it's nothing major:

2520                    if (ret)
2521                            BUG(); /* FIXME break ? */

It used to be just a break out of the loop there, so that's the reason
it doesn't panic with 3.1+for-linus.  I'll investigate further and fix
this.

Thanks,

		Ilya

