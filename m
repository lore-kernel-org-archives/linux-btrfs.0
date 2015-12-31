Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35629 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbLaVXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 16:23:36 -0500
Received: by mail-io0-f182.google.com with SMTP id 77so70792740ioc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 13:23:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
Date: Thu, 31 Dec 2015 13:23:35 -0800
Message-ID: <CAN05THS2=MFKwETJMPDz_FntDVFwfgbaY4Aros9=B4rhOF91qQ@mail.gmail.com>
Subject: Re: btrfs fail behavior when a device vanishes
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 12:11 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is a torture test, no data is at risk.
>
> Two devices, btrfs raid1 with some stuff on them.
> Copy from that array, elsewhere.
> During copy, yank the active device.
>
> dmesg shows many of these:
>
> [ 7179.373245] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
> 652123, rd 697237, flush 0, corrupt 0, gen 0

For automated tests a good way could be to build a multi device btrfs filesystem
ontop of it.
For example STGT exporting n# volumes and then mount via the loopback interface.
Then you could just use tgtadm to add / remove the device in a
controlled fashion and to any filesystem it will look exactly like if
you pulled the device physically.

This allows you to run fully automated and scripted "how long before
the filesystem goes into total dataloss mode" tests.



If you want more fine control than just plug/unplug on a live
filesystem , you can use
https://github.com/rsahlberg/flaky-stgt
Again, this uses iSCSI but it allows you to script event such as
"this range of blocks are now Uncorrectable read error" etc.
To automatically stress test that the filesystem can deal with it.


I created this STGT fork so that filesystem testers would have a way
to automate testing of their failure paths.
In particular for BTRFS which seems to still be incredible fragile
when devices fail or disconnect.

Unfortunately I don't think anyone cared very much. :-(
Please BTRFS devs,  please use something like this for testing of
failure modes and robustness. Please!



>
> Why are the write errors nearly as high as the read errors, when there
> is only a copy from this device happening?
>
> Is Btrfs trying to write the read error count (for dev stats) of sdc1
> onto sdc1, and that causes a write error?
>
> Also, is there a command to make a block device go away? At least in
> gnome shell when I eject a USB stick, it isn't just umounted, it no
> longer appears with lsblk or blkid, so I'm wondering if there's a way
> to vanish a misbehaving device so that Btrfs isn't bogged down with a
> flood of retries.
>
> In case anyone is curious, the entire dmesg from device insertion,
> formatting, mounting, copying to then from, and device yanking is here
> (should be permanent):
> http://pastebin.com/raw/Wfe1pY4N
>
> And the copy did successfully complete anyway, and the resulting files
> have the same hashes as their originals. So, yay, despite the noisy
> messages.
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
