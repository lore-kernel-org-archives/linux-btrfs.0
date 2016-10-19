Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19390 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753671AbcJSVgh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 17:36:37 -0400
Subject: Re: Monitoring Btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
 <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
 <a813c70b-e230-726e-e0bc-e8f15848cc44@gmail.com>
 <a12e3815-98c3-5ab6-179b-2c8efb841533@oracle.com>
 <9bbe4174-dcb0-ec14-2da8-eaf9b4f4ab82@gmail.com>
 <bf0b049c-cd7a-00f4-cc20-68d50a7be039@oracle.com>
 <dd66793c-709a-1b7e-09d0-99f1b745f908@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f86ec2a9-16b7-0961-0685-86e7b094b3a3@oracle.com>
Date: Thu, 20 Oct 2016 05:38:55 +0800
MIME-Version: 1.0
In-Reply-To: <dd66793c-709a-1b7e-09d0-99f1b745f908@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/19/16 21:33, Austin S. Hemmelgarn wrote:
> On 2016-10-19 09:06, Anand Jain wrote:
>>
>>
>> On 10/19/16 19:15, Austin S. Hemmelgarn wrote:
>>> On 2016-10-18 17:36, Anand Jain wrote:
>>>>
>>>>
>>>>>>>> I would like to monitor my btrfs-filesystem for missing drives.
>>>>
>>>>
>>>>>>> This is actually correct behavior, the filesystem reports that it
>>>>>>> should
>>>>>>> have 6 devices, which is how it knows a device is missing.
>>>>
>>>>
>>>>>>  Missing - means missing at the time of mount. So how are you
>>>>>> planning
>>>>>> to monitor a disk which is failed while in production ?
>>>>
>>>>> No, in `btrfs fi show` it means that it can't find the device.
>>>>
>>>>  'btrfs fi show' is miss-leading as compared to 'btrfs fi show -m'
>>>>  -m tells btrfs-kernel perspective of the devices, as of now
>>>>  there is no code in the kernel which changes the device status
>>>>  while its mounted (expect for readonly, which is irrelevant in
>>>>  raid1 with 1 disk failed).
>>
>>> Actually, that's exactly how I would expect each of them to behave.  We
>>> need some way to get both the state the kernel thinks the FS is in, and
>>> the state it's actually in (according to the tools, not the kernel), and
>>> '-m' reporting kernel state while no '-m' reports actual state is
>>> exactly what I would expect in this case.
>>
>>
>>> That leads also to another way I hadn't thought of to monitor a
>>> filesystem.  The output of 'fi show' with and without '-m' should match
>>> if the filesystem was healthy when mounted and is still healthy, if they
>>> don't, then something is wrong.
>>
>>
>>>>> 1. Filesystem flags.  These will change when the filesystem goes
>>>>> degraded,
>>>>
>>>>   Which flag is in question here. ?
>>> I should clarify here, I mean the mount options, I'm just used to the
>>> monit terminology (which was not well picked in this case).  The big one
>>> to watch is the read-only flag, as BTRFS will force a filesystem
>>> read-only (which updates the mount options).  Any change to the mount
>>> options though without manual intervention is generally a sign that
>>> _something_ is wrong.
>>
>>
>>  btrfs-progs shouldn't add its own intelligence in determining the
>>  device state, it should be a transparent tool to report status from
>>  the btrfs-kernel. So I opposed to the patches such as
>>
>>     commit 206efb60cbe3049e0d44c6da3c1909aeee18f813
>>     btrfs-progs: Add missing devices check for mounted btrfs.
>>
>>  There are many ways a device can fail/recover in the SAN environment,
>>  these device state managing intelligence should be at one place and
>>  in the kernel. The volume manager part of the code in the kernel
>>  is incomplete.
>>
> I don't agree that the management should be completely unified or that
> the tools should just report kernel state.  The tools have to have some
> way to check device state for unmounted filesystems because they have to
> operate on unmounted filesystems, and because until the kernel gets
> smart enough to actually handle device state properly, some method is
> needed to check the actual state of the devices.  Even once the kernel
> is smart enough, it's still helpful to see without mounting a filesystem
> whether or not all the devices are there, and if we ever switch to a
> real mount helper (which I am in favor of for multiple reasons), we'll
> need device state checking in userspace for that too.


  Bit out of context. here its about monitoring device when FS
  is mounted, in this context, if there is tool which would make
  its own intelligence without kernel, then that's wrong.




> Take a look for at LVM.  The separation of responsibilities there is
> ideally what we should be looking at long term for BTRFS.  The userspace
> components tell the kernel what to do, and list both kernel state _and_
> physical state in a readable manner.  The kernel tracks limited parts of
> the state (only for active LV's, so the equivalent of mounted
> filesystems, and even then only what it needs to track (Is this RAID
> volume in sync?  Is that snapshot or thin storage pool getting close to
> full?)), and sends notifications to a userspace component which then
> acts on those conditions (possibly then telling the kernel what to do in
> response to them).  On top of that, the userspace components don't
> require a kernel which supports them for any off-line operations, and
> the kernel works fine with older userspace.  Both userspace and the
> kernel handle missing devices (userspace tools report them, the kernel
> refuses to activate LV's that require them).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
