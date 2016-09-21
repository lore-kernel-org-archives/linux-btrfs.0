Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dmz.skyward.com ([12.28.97.8]:44931 "EHLO dmz.skyward.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757617AbcIUPYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:24:24 -0400
From: Jeffrey Michels <jeffreym@skyward.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Filesystem will remount read-only
Date: Wed, 21 Sep 2016 15:24:19 +0000
Message-ID: <8AC4324B47948D40A1031D5AB7D077820141E7CF70@mailstore.skyward.com>
References: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
 <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com>
In-Reply-To: <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've booted into the latest nightly build of Fedora and run btrfs rescue super-recover -v and also btrfs check.

Super-recover reports that "All supers are valid, no need to recover."  Btrfs check displays the same errors as before:

Parent trasid verified failed on xxxx wanted xxxx found xxxxx
Ignoring transid failure
Leaf parent key incorrect xxxxxxx
Bad block xxxxxxxxxxx
Errors found in extend allocation tree or chunk allocation.

The check eventually fails with Segmentation fault (core dumped.)

Attempting to mount with -o recovery results in the error "Can't read superblock."  I am able to mount the filesystem read-only however attempting to copy all of the data off has been unsuccessful.  It appears to hit a bad area and just hangs.

Is there anything else I can try?

Thank you for your insight,

Jeff Michels

-----Original Message-----
From: chris@colorremedies.com [mailto:chris@colorremedies.com] On Behalf Of Chris Murphy
Sent: Friday, September 16, 2016 7:08 PM
To: Jeffrey Michels
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Filesystem will remount read-only

On Fri, Sep 16, 2016 at 8:57 AM, Jeffrey Michels <jeffreym@skyward.com> wrote:
> Hello,
>
> I have a system that has been in production for a few years.  The SAN the VM was running on had a hardware failure about a month ago and now one of the two btrfs filesystems will remount after boot read-only.  Here is the system information:
>
> uname -a
>
> Linux retain 3.0.101-0.47.71-default #1 SMP Thu Nov 12 12:22:22 UTC 
> 2015 (b5b212e) x86_64 x86_64 x86_64 GNU/Linux
>
> Btrfs --version
>
> Btrfs v0.20+

Impressive that it's been running in production this long and with old kernel. I like it!

Anyway, you could try mounting with -o recovery and see if that works.
That's about the only thing I'd trust with such an old kernel and btrfs-progs. I don't even think it's worth trying the btrfsck on v0.20 just to see what the problems might be, and certainly not for actually using the repair mode.  Actually I'm not even sure progs that old even does repairs, it might be the era of notify only.

If -o recovery doesn't work, you'll need to use something newer, you could use one of:

Fedora Rawhide nightly with 4.8rc6 kernel and btrfs-progs 4.7.2. This is a small netinstall image. dd to a USB stick, choose Troubleshooting option, then the Rescue option, then after startup use the 3 option to get to a shell where you can try to mount normally, or use btrfs-check. Limited tty, no sshd.
https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160914.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20160914.n.0.iso.n.0.iso

Or something more official with published hash's for the image and a GUI, Fedora 24 workstation has kernel 4.5.5 and btrfs-progs 4.5.2 https://getfedora.org/en/workstation/download/




--
Chris Murphy

iCon 2017 Registration is Now Open!
Agents of Innovation
March 8 - 10, 2017
TradeWinds Island Resort, St. Pete Beach, Florida
Register today at: www.skyward.com/icon

PRIVILEGED AND CONFIDENTIAL
Skyward Communication

This is a transmission from Skyward, Inc. and may contain information which is privileged, confidential, and protected by service work privileges.  The response is in direct relationship to the information provided to Skyward.   If you are not the addressee, note that any disclosure, copying, distribution, or use of the contents of this message is prohibited.  If you have received this transmission in error, please destroy it and notify us immediately at 715-341-9406.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
