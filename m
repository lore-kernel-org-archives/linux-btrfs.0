Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47381 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbBLGZn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 01:25:43 -0500
Message-ID: <54DC475C.4000002@oracle.com>
Date: Thu, 12 Feb 2015 14:25:32 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs
 layout
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com> <1423439785-10260-24-git-send-email-anand.jain@oracle.com> <20150211185259.GM28877@twin.jikos.cz>
In-Reply-To: <20150211185259.GM28877@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for commenting. more below.


On 02/12/2015 02:52 AM, David Sterba wrote:
> On Mon, Feb 09, 2015 at 07:56:24AM +0800, Anand Jain wrote:
>> This adds an enhancement to show the seed fsid and devices.
>>
>> The way sprouting handles fs_devices:
>>        clone seed fs_devices and add to the fs_uuids
>>        mem copy seed fs_devices and assign to fs_devices->seed (move dev_list)
>>        evacuate seed fs_devices contents to hold sprout fs devices contents
>>
>>    So to be inline with this fs_devices changes during seeding,
>>    represent seed fsid under the sprout fsid, this is achieved
>>    by using the kobject_move()
>>
>> eg: showing two levels of seeding.
>
> That's new to me, how does nested seeding work?

  I called below operation as nested seeding:
     mark a sprout as seed, mount it, add a new sprout to it.
     eg:
      mkfs.btrfs /dev/sdz
      btrfstune -S 1 /dev/sdz
      mount /dev/sdz /btrfs
      btrfs dev add /dev/sdy /btrfs
      umount /btrfs
      btrfstune -S 1 /dev/sdy
      mount /dev/sdy /btrfs
      btrfs dev add /dev/sdx /btrfs


(Its bit complicated during seeding, as fs_devices and device move 
around. /proc/fs/btrfs/devlist helped to understand. its in the ML)

{
Since we are on this topic: btrfs-progs shouldn't have had this patch:
    git log -p 2513077
-------------------------
commit 2513077f2f830b4bc83d528bfb6979eb461918bd
Author: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Date:   Mon Oct 6 18:16:46 2014 +0800

     btrfs-progs: fix device missing of btrfs fi show with seed devices
-------------------------

it doesn't work with nested seed as I commented
   http://marc.info/?l=linux-btrfs&m=141102300324251&w=2
-------------------------
   btrfs fi show -d
warning devid 1 not found already
warning devid 2 not found already
Check tree block failed, want=29425664, have=0
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=29360128, have=0
read block failed check_tree_block
-------------------------

I haven't see next version of this patch from Gui. (Gui ?, copied)
}


>> find /sys/fs/btrfs/ -type d -name devices -exec ls {} \; -print
>>
>> sde
>> /sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/devices
>> sdd
>> /sys/fs/btrfs/8c2772d4-6951-43c3-89b6-3ab3c70a13f8/f7ef2904-ce89-4421-bfb0-49fd999e9a0b/53ac3265-0c34-4afd-9453-cc0d1a07be64/devices
>
> The plain uuid is IMHO not the best naming convention, although it's
> acceptable in the global list in /sys/fs/btrfs/* I'd rather avoid it if
> it's mixed with other files.

just to clarify, the above aren't uuid, they are fsid rather, sorry I 
didn't mention.
   sde
   /sys/fs/btrfs/sprout-fsid/seed-fsid/devices
   sdd
   /sys/fs/btrfs/sprout-fsid/seed-fsid/2nd-level-seed-fsid/devices

In any case, as in previous RFC patch
   [PATCH RFC] btrfs: add sysfs layout to show volume info
uuid will be there, the reasons are first,
btrfs kernel the device uniqueness is determined by fsid-uuid-devid 
combination (which means if _any one_ of these is different its going to 
create a new struct btrfs_device), so its easy to be inline with that. 
name abstraction links on top of it can be created as well.
next,
we originally have device name link under /sys/fs/btrfs/fsid/device. 
Since it made first, I doubt if we could alter that to a kobject dir 
instead of link?. Some script might be using it. So I am planning to put 
uuid under /sys/fs/btrfs/fsid/device to contain info about the device. 
as shown in the RFC patch above.

> Would it be enough to print all relevant seeding information into a
> single file? If the "UUID" directoreis do not contain anything else,
> that would be IMHO best.

Hmm nope it will contain more info.

> Do the seeding fsids exist on their own in /sys/sf/btrfs? I haven't
> tested the patchset so I'd probably find that out myself.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
