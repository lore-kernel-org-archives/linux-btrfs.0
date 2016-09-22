Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:46112 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755988AbcIVMor (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 08:44:47 -0400
Subject: Re: unable to handle kernel paging request - btrfs
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57E3D23C.3050905@applied-asynchrony.com>
Date: Thu, 22 Sep 2016 14:44:44 +0200
MIME-Version: 1.0
In-Reply-To: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/16 14:18, Rich Freeman wrote:
> I have been getting panics consistently after doing a btrfs replace
> operation on a raid1 and rebooting.  I linked a photo of the panic; I
> haven't been able to get a text capture of it.
> 
> https://ibin.co/2vx0HhDeViu3.jpg
> 
> I'm getting this error on the latest 4.4, 4.1, and even on an old
> 3.18.26 kernel I had lying around.

What happens when you try to boot e.g. SystemRescueCD?
If it is what I think it is (see below) then that should start bombing
as well.

> I'm able to boot into single-user mode and if I don't start any
> processes the system seems fairly stable.  I am also able to start a
> btrfs balance and run that for several hours without issue.  If I
> start launching services the system will tend to panic, though how
> many processes I can launch will vary.  I don't think that it is a
> particular file being accessed that is triggering the issue since the
> point where it fails varies.  I suspect it may be load-related.

If the SystemRescue method does not work then you have either
an overheating/dying CPU or - more likely - bad memory.

Another - probably unlikely, but not impossible - option would be to
delete the swap file, if you have one. I've seen some super-strange
things with corrupt or incorrectly created swap *even if it isn't
heavily used*, right after boot. E.g. if your swapfile was fallocated
instead of dd'ed and lives on ext4 or XFS, you *must* use the -z option
to pre-touch all extents.

Or maybe it's the ghost of ZFS, if that's patched in as well.. :-)

-h

