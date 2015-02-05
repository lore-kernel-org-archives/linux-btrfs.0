Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:54326 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbbBEGDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 01:03:19 -0500
Received: by mail-yh0-f45.google.com with SMTP id f73so2601333yha.4
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 22:03:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D2E62E.7080208@pobox.com>
References: <mau7vs$pjj$1@ger.gmane.org>
	<CAJCQCtSXJZ4paKiZBNDOp-yKccrLbizmGDj_8y5k5EC-9DFjXg@mail.gmail.com>
	<54D2E62E.7080208@pobox.com>
Date: Wed, 4 Feb 2015 23:03:18 -0700
Message-ID: <CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com>
Subject: Re: Btrfs subvolume question
From: Chris Murphy <lists@colorremedies.com>
To: Robert White <rwhite@pobox.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Markus Moeller <huaraz@moeller.plus.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 4, 2015 at 8:40 PM, Robert White <rwhite@pobox.com> wrote:
> In terms of actual LVs he only seems to have _root_ _opt_ _var_ and _usr_
> once you strip away the various noise components.

I think you win the prize on this. I saw that, and ignored the fact
the LV name was identical for so many of these mount points.

> In particular oddity fassion /var is a different device but /var/log goes
> back to the root device.

Yes. And so do

/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /boot/grub2/x86_64-efi
/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /boot/grub2/i386-pc

> They also might be bind mounts instead of subvol= mounts. I'd have to see
> /etc/fstab.
>
> The output of btrfs subvol list  on / /var /usr and /opt would be nice as
> well.

The fstab would pretty much reveal the whole story.

The intended Btrfs only layout on openSUSE actually causes a  big
problem for the Fedora installer right now. A combination of many
subvolumes and snapshots taken by default, and the way the Fedora
installer UI presents and makes them essentially impossible to remove
as a whole volume.
https://bugzilla.redhat.com/show_bug.cgi?id=1185117

This is the inevitable outcome of distributions not coming to a sane
consensus on a boot loading specification, made worse by no consensus
on how to manage/name snapshots and assemble things at boot time.
Everyone has their own idea being implemented so we get even more
fragmentation as if these are different operating systems that just so
happen to share a kernel.

So this is just the beginning of crazy installer behaviors and
pathological problems due to lack of distributions getting along at
anything above the kernel (and systemd). I actually like the
subvolume/snapshot naming convention suggested here:
http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
The ability to migrate such layout between systems is a lot more
functional, discoverable, and cleaner than either Fedora's root, boot,
home subvolumes method; or openSUSE's let's make 18 subvolumes that no
one will like to manually btrfs send/receive more than once in their
lifetime, assuming reading the fstab doesn't cause a pill popping
episode.

-- 
Chris Murphy
