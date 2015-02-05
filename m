Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45375 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbbBEU2Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 15:28:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJT2F-0007tV-5a
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 21:28:23 +0100
Received: from moeller.plus.com ([81.174.172.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 21:28:23 +0100
Received: from huaraz by moeller.plus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 21:28:23 +0100
To: linux-btrfs@vger.kernel.org
From: "Markus Moeller" <huaraz@moeller.plus.com>
Subject: Re: Btrfs subvolume question
Date: Thu, 5 Feb 2015 20:28:10 -0000
Message-ID: <mb0jp0$pnd$1@ger.gmane.org>
References: <mau7vs$pjj$1@ger.gmane.org><CAJCQCtSXJZ4paKiZBNDOp-yKccrLbizmGDj_8y5k5EC-9DFjXg@mail.gmail.com><54D2E62E.7080208@pobox.com> <CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
In-Reply-To: <CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for looking at this.  I did post the fstab  in the original post. 
Here it is again:

# cat /etc/fstab
UUID=d300b5ad-372b-4f86-b952-4aa4fc62a84e swap swap defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f / btrfs defaults 0 0
UUID=fd14684f-1950-4f33-95b5-b54f069b4fe0 /boot ext4 acl,user_xattr 1 2
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /boot/grub2/i386-pc btrfs 
subvol=boot/grub2/i386-pc 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /boot/grub2/x86_64-efi btrfs 
subvol=boot/grub2/x86_64-efi 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /home btrfs subvol=home 0 0
UUID=f535177b-18a5-443c-8236-96105d58a621 /opt btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /srv btrfs subvol=srv 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /tmp btrfs subvol=tmp 0 0
UUID=62ffc2f3-7e3a-433e-8a4e-5a89a352f8cf /usr btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /usr/local btrfs subvol=usr/local 
0 0
UUID=323ba68a-e7ed-4f0f-9716-dcad92bb9808 /var btrfs defaults 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/crash btrfs subvol=var/crash 
0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/mailman btrfs 
subvol=var/lib/mailman 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/named btrfs 
subvol=var/lib/named 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/lib/pgsql btrfs 
subvol=var/lib/pgsql 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/log btrfs subvol=var/log 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/opt btrfs subvol=var/opt 0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/spool btrfs subvol=var/spool 
0 0
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /var/tmp btrfs subvol=var/tmp 0 0
/dev/export_vg/export_lv /export xfs defaults 1 2
/dev/export_vg/src_lv /src xfs defaults 1 2
UUID=7a681ad4-5b82-4e78-9b20-1d719c89fe6f /.snapshots btrfs 
subvol=.snapshots 0 0


The only thing I intended was to separate /,  /var, /opt, /usr and /boot as 
I was used to, to avoid for example /var/log filling up the root filesystem 
( but now this fails :-( )

Markus

"Chris Murphy"  wrote in message 
news:CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com...

On Wed, Feb 4, 2015 at 8:40 PM, Robert White <rwhite@pobox.com> wrote:
> In terms of actual LVs he only seems to have _root_ _opt_ _var_ and _usr_
> once you strip away the various noise components.

I think you win the prize on this. I saw that, and ignored the fact
the LV name was identical for so many of these mount points.

> In particular oddity fassion /var is a different device but /var/log goes
> back to the root device.

Yes. And so do

/dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% 
/boot/grub2/x86_64-efi
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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 


