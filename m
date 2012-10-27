Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:50795 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab2J0B6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 21:58:52 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so1552207dak.19
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 18:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	<64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
	<CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com>
	<B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com>
Date: Fri, 26 Oct 2012 19:58:52 -0600
Message-ID: <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
Subject: Re: Naming of subvolumes
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 9:54 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 26, 2012, at 2:27 AM, Richard Hughes <hughsient@gmail.com> wrote:
>
>
>>> And if you're going to apply the upgrade to the snapshot, or to the top level file system?
>>
>> That's a very good question. I was going to apply the upgrade to the
>> top level file system, and then roll-back to the old snapshot if the
>> new upgrade state does not boot to a GUI. It would work equally well
>> applying the update to the snapshot and then switching to that,
>> although I don't know how well userspace is going to cope switching to
>> a new subvolume at early-runtime given the fact we're running the
>> upgrade itself from the filesystem and not in a special initrd or
>> something. Also, we need to ready out lots of upgrade data (200Mb+?)
>> from somewhere, so doing this on the snapshot would mean creating the
>> snapshot and copying the data there *before* we reboot to install
>> upgrades, and we really want to create the snapshot when we're sure
>> the system will boot.
>
> a. Upgrade top level:
> Maybe download upgrade data to /tmp, upon completion snapshot the current system state, then copy the upgrade data to persistent storage and reboot; upgrade of top level boot root begins. The snapshot is the regressive state in case of failure.
>
> b. Upgrade snapshot:
> Create snapshot, mount it somewhere; download upgrade data to a location within the snapshot; reboot from the snapshot, it upgrades itself and cleans up. The top level is the regressive state in case of failure.
>
> Either way, 200MB of downloaded (and undeleted) upgrade data isn't stuck in a snapshot after it's used. And either way the snapshot is bootable.
>
> If you get sufficient metadata in the snapshot, then you can name/rename the snapshots whatever you want. I'd also point out it's valid for the user to prefer a different organization, i.e. instead of Fedora taking over the top level of a btrfs volume, to create subvolumes Fedora 17, Fedora 18, Ubuntu 12X, etc., at the top level, and insert boot and root and possibly home in those. In which case the upgrade mechanism should still work.
>
>>
>>> So I'm going to guess that you will actually create a subvolume named something like @system-upgrade-20121025, and then snapshot root, boot, and home into that subvol?
>>
>> Not /home. Packages shouldn't be installing stuff there anyway, and
>> /home is going to typically much bigger than /root or /boot.
>
> OK so small problem here is that today /etc/fstab is pointing to the home subvolume in a relative location to the default subvolume. The fstab mount option is subvol=home, not subvol=/home, not subvolid=xxx.
>
> So if you want to use changing default subvolumes to make the switch between the current updated state, and rollback states, (which is milliseconds fast), which also means no changes needed to grub's core.img or grub.cfg (since those use relative references for boot and root), a change is needed for home to use an absolute reference: either subvol=/home or use subvolid= in the fstab.
>
> While a bit more obscure in the /etc/fstab the subvolid= is more reliable. That home can be renamed or moved anywhere and it'll still work. I think it's legitimate for a user to create or want
>
>
>>> If the upgrade is not successful, you change the default subvolume ID to that of @system-upgrade-20121025.
>>
>> I was actually thinking of using btrfs send | btrfs receive to roll
>> back the root manually. It would be better if btrfs could swap the
>> subvolume ID's of @system-upgrade-20121025 and 0, as then we don't get
>> a snapshot that's useless.
>
> I haven't tried btrfs send/receive for this purpose, so I can't compare. But btrfs subvolume set-default is faster than the release of my finger from the return key. And it's easy enough the user could do it themselves if they had reasons for regression to a snapshot that differ than the automagic determination of the upgrade pass/fail.
>
> The one needed change, however, is to get /etc/fstab to use an absolute reference for home.
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'd argue that everything should be absolute references to subvolumes
(/@home, /@, etc), and neither set-default nor subvolume id's should
be touched.  There's no need, as you can simply mv those around (even
while mounted).  More importantly, it doesn't result in a case where
the fstab in one snapshot points its mountpoint to a different
snapshot, with all the hilarity that would cause over time, and also
allows multiple distros to be installed on the same filesystem without
having them stomp on each others set-defaults: /@fedora, /@rawhide,
/@ubuntu, /@home, etc.
