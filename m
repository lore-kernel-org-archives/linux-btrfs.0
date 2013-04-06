Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35884 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163044Ab3DFAOw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 20:14:52 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so4190143lbi.8
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2013 17:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPL5yKf=Lw7qPLrkVOhKC=B1Ap+Y=JxMzJ0SUdtG=QyjfBWKEg@mail.gmail.com>
References: <CAPL5yKf=Lw7qPLrkVOhKC=B1Ap+Y=JxMzJ0SUdtG=QyjfBWKEg@mail.gmail.com>
Date: Fri, 5 Apr 2013 20:14:51 -0400
Message-ID: <CAPL5yKcc2GxiQyVm3c9667COg12vaXCxM-WA-Y65oyQC4ik6HQ@mail.gmail.com>
Subject: Re: filesystem stuck RO after losing a device
From: Dan Merillat <dan.merillat@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 5, 2013 at 7:43 PM, Dan Merillat <dan.merillat@gmail.com> wrote:
>
> first off: this was just junk data, and is all readable in degraded
> mode anyway.
>
> Label: 'ROOT'  uuid: cc80d150-af98-4af4-bc68-c8df352bda4f
>         Total devices 2 FS bytes used 138.00GB
>         devid    1 size 232.79GB used 189.04GB path /dev/sdc2
>         devid    3 size 232.89GB used 14.06GB path /dev/sdb
>
> The filesystem was created in 3.6 or so, and abandoned when I moved to
> a SSD as my main root.  Playing around with it, I added a raw disk to
> it and did some IO but wanted that disk back.  Due to the automatic
> upgrade to 'dup' when adding a second device, I couldn't do a btrfs
> dev delete so I ended up just unmounting it and reformatting /dev/sdb
> as a backup for my SSD.
>
> Given the 'dup' profile, I should be able to just blow away the stub
> of sdb and continue using sdc, but I can't figure out any way to get
> it to allow that.

$ btrfs fi df /mnt/t2
Data: total=173.01GB, used=136.76GB
System, DUP: total=40.00MB, used=32.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=14.00GB, used=504.24MB
Metadata, DUP: total=1.00GB, used=756.14MB
Metadata: total=8.00MB, used=0.00

So the problem is I ended up with DUP profile instead of RAID1.  Is
there any way to force it to mount RW and update that? (or update
offline?)

That's a usability issue, actually - adding a disk to a single makes
it so that you can't fail gracefully unless you know to run a balance
-draid1 -mraid1.  Which I know, after looking up why this failed.
Unfortunately, I can't recover from this.
