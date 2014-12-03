Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:41203 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbaLCIY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 03:24:26 -0500
Message-ID: <547EC8B5.1060002@inwind.it>
Date: Wed, 03 Dec 2014 09:24:21 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Anand Jain <Anand.Jain@oracle.com>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Robert White <rwhite@pobox.com>, Chris Mason <clm@fb.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>	<547CA4E7.8060209@pobox.com>	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>	<547CF8B1.4000303@pobox.com>	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>	<547D6F42.9000009@inwind.it> <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com> <547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com> <547DAF2A.7020902@gmail.com> <547E0EE5.2040504@ubuntu.com>
In-Reply-To: <547E0EE5.2040504@ubuntu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/2014 08:11 PM, Phillip Susi wrote:
> On 12/2/2014 7:23 AM, Austin S Hemmelgarn wrote:
>> Stupid thought, why don't we just add blacklisting based on device
>> path like LVM has for pvscan?
> 
> That isn't logic that belongs in the kernel, so that is going down the
> path of yanking out the device auto probing from btrfs and instead
> writing a mount.btrfs helper that can use policies like blacklisting
> to auto locate all of the correct devices and pass them all to the
> kernel at mount time.
> 
I am thinking about that. Today the device discovery happens:
a) when a device appears, two udev rules run "btrfs dev scan <device>"

/lib/udev/rules.d/70-btrfs.rules
/lib/udev/rules.d/80-btrfs-lvm.rules

b) during the boot it is ran a "btrfs device scan", which scan all 
the device (this happens in debian for other distros may be different)

c) after a btrfs.mkfs, which starts a device scan on each devices of
the new filesystem

d) by the user


Regarding a), the problem is simply solved adding a line like:

ENV{DM_UDEV_LOW_PRIORITY_FLAG}=="1", GOTO="btrfs_end"

Regarding c), it is not a problem

Regarding b) and d), the only solution that I found is to query the 
udev DB inside the "btrfs dev scan" program and to skip the devices
with DM_UDEV_LOW_PRIORITY_FLAG==1. But implementing this, it would 
solve all the points a), b), c), d) with one shot !


BR
G.Baroncelli

P.S.
This is the comment made by LVM by DM_UDEV_LOW_PRIORITY_FLAG:

/*
 * DM_UDEV_LOW_PRIORITY_FLAG is set in case we need to instruct the
 * udev rules to give low priority to the device that is currently
 * processed. For example, this provides a way to select which symlinks
 * could be overwritten by high priority ones if their names are equal.
 * Common situation is a name based on FS UUID while using origin and
 * snapshot devices.
 */
#define DM_UDEV_LOW_PRIORITY_FLAG 0x0010

https://git.fedorahosted.org/cgit/lvm2.git/tree/libdm/libdevmapper.h#n1969



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
