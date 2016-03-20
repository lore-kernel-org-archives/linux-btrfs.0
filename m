Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36614 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcCTTNS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 15:13:18 -0400
Received: by mail-ig0-f179.google.com with SMTP id nk17so57578760igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 12:13:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
References: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
Date: Sun, 20 Mar 2016 13:13:17 -0600
Message-ID: <CAJCQCtToig8o1rLzBX2Tva2V6C6aam63s2DmcHYyF_r69yZ3kA@mail.gmail.com>
Subject: Re: unable to mount btrfs partition, please help :(
From: Chris Murphy <lists@colorremedies.com>
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2016 at 3:18 AM, Patrick Tschackert <Killing-Time@gmx.de> wrote:
> Thanks for answering again!
> So, first of all I installed a newer kernel from the backports as per Nicholas D Steeves suggestion:
>
> $ apt-get install -t jessie-backports linux-image-4.3.0-0.bpo.1-amd64
>
> After rebooting:
> $ uname -a
> Linux vmhost 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.5-1~bpo8+1 (2016-02-23) x86_64 GNU/Linux
>
> But the problem with mounting the filesystem persists :(
>
>> OK I went back and read this again: host is managing the md raid5, the
>> guest is writing Btrfs to an "encrypted container" but what is that? A
>> LUKS encrypted LVM LV that's directly used by Virtual Box as a raw
>> device? It's hard to say what layer broke this. But the VM crashing is
>> in effect like a power failure, and it's an open question (for me) how
>> this setup deals with barriers. A shutdown -r now should still cleanly
>> stop the array so I wouldn't expect there to be an array problem but
>> then you also report a device failure. Bad luck.
>
> The host is managing an md raid 6 (/dev/md0), and I had an encrypted volume (via cryptsetup) on top of that device.
> The host mounted the btrfs filesystem contained in that volume, and the VM wrote to the filesystem as well using a virtualbox shared folder.

OK well to me the VM doesn't seem related off hand. Ultimately its
only the host writing to the filesystem, even for the shared folder.
The guest VM has no direct access to do Btrfs writes, it's something
like a network-like shared folder.


> After this, I think I'll just do away with the virtual machine on this host, as the app contained in that vm can also run on the host.
> I tried to be fancy, and it seems to needlessly complicate things.

virt-manager or gnome-boxes work better, although you lose shared
folder, you'll have to come up with a work around, like using NFS.


> $ for i in /sys/class/scsi_generic/*/device/timeout; do echo 120 > "$i"; done
> (I know this isn't persistent across reboots...)

Correct.


-- 
Chris Murphy
