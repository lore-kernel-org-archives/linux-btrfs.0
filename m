Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from odin.sdf-eu.org ([178.63.35.194]:60645 "EHLO sdfeu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbcJZLxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 07:53:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 26 Oct 2016 13:52:47 +0200
From: none <ytrezq@sdf-eu.org>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: How to recover a filesystem without formatting nor using the
 btrfs check command.
In-Reply-To: <08227414-b241-28a5-bbc6-7fb21d4b3e62@cn.fujitsu.com>
References: <580944C7.103@sdf-eu.org>
 <8c5ae48c-4af6-42d9-be0f-06d232764ff2@cn.fujitsu.com>
 <36f56365-27ac-878e-c5fb-f414646eda3a@sdf-eu.org>
 <61df188a-bc12-c9c4-0322-766df4fb18c0@cn.fujitsu.com>
 <a8b030a4fab174ade203bf061151f270@mx.sdfeu.org>
 <08227414-b241-28a5-bbc6-7fb21d4b3e62@cn.fujitsu.com>
Message-ID: <7dcfffa62234ff0fa5ae060f75df25f1@mx.sdfeu.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2016-10-26 03:43, Qu Wenruo a écrit :
> Unfortunately, low memory mode is right here.
> 
> If btrfs-image dump the image correctly, your extent tree is really 
> screwed up.
> 
> And how badly it is screwed up?
> It only contains the basic block group info.
> Almost empty, without any really useful EXTENT_ITEM/METADATA_ITEM.
> You can check it by btrfs-debug-tree -t extent.
> Normally, one EXTENT_DATA or tree block should have corresponding
> EXTENT_ITEM or METADATA_ITEM in extent tree.
> 
> But in your dump, I only find EXTENT_ITEM less than a dozen, which is
> totally abnormal for the used size of your fs.
Please note df -h report 55Gb used due to a very high compression ratio. 
Basically most of the theoretical used space is done by less than 100 
files. I want to delete them
> That's why lowmem mode is reporting so many backref lost.
Whithout the lowmem mode, only 3 lines are reported :

Failed to find [75191291904, 168, 4096]
btrfs unable to find ref byte nr 75191291904 parent 0 root 1  owner 1 
offset 0
Failed to find [75191316480, 168, 4096]
btrfs unable to find ref byte nr 75191316480 parent 0 root 1  owner 0 
offset 1
parent transid verify failed on 75191349248 wanted 3555361 found 3555362
Ignoring transid failure

and then it’s cpu locked.

> It's almost a miracle that you can still write data into the fs.
> And I heavily doubt the correctness of your existing files.
They are definitely correct. I have several root filesystem and I can 
chroot to all of them (though I’m mounting the partition readonly in 
order to avoid dangerous writes in that case). In each case I tried 
python and ruby cgi scripts.
> As extent tree is screwed up, it's completely possible new write are
> overwriting existing data.
Though I only attempted to write to 3 files. But yes, this was something 
I suspected : that writing damage things.
> The only chance seems to be --init-extent-tree, but that's very
> dangerous and I highly suspect the screwed up extent tree is caused by
> interrupted extent tree rebuild.
The problem is --init-extent-tree implies --repair which discard 
--mode=lowmem and cause the dead lock : 
https://bugzilla.kernel.org/show_bug.cgi?id=178781
> Thanks,
> Qu
> 
And finally, I found several corrupt directories yesterday.

Do you mean it’s impossible to rescue anything by repairing ? (this is 
something I doubt since most files are valid)

Thank you.
> At 10/26/2016 02:19 AM, none wrote:
>> Le 2016-10-25 05:04, Qu Wenruo a écrit :
>>> At 10/25/2016 01:54 AM, none wrote:
>>>> So do you mean lowmem is also low cpu ?
>>> 
>>> Not sure, but lowmem is high IO.
>>> And by design, it won't cause dead look unless there is a looping 
>>> tree
>>> block. But that will be detected by check_tree_block().
>>> 
>>> So, it just avoids any possible dead loop AFAIK.
>>> 
>>>> Indeed here's the output if the metadata image isn't enough (it
>>>> termintes correctly with the --lowmem option). I must recognize even
>>>> without the --repair option, btrfs check hangs.
>>> 
>>> I just forgot you have uploaded the image dump.
>>> I'll check it.
>>> 
>>> But according to lowmem output, it seems all your extent tree is
>>> screwed up, maybe that's the cause of the problem?
>> I don’t think so, I can read and write to most files and no directory 
>> is
>> corrupt (even after running the btrfsck with lowmem).
>> 
>> But of course, as the filesystem is corrupt, I avoid to mount it.
>> 
>> Looks like the output of the tool is wrong.
>>> 
>>> Thanks,
>>> Qu
>>>> 
>>>> regards,
>>>> 
>>>> Le 24/10/2016 à 03:15, Qu Wenruo a écrit :
>>>> 
>>>>> You could try to use --mode lowmem, which doesn't ever use any loop 
>>>>> to
>>>>> get next block, but iterating trees.
>>>>> 
>>>>> Current in mainline btrfs-progs, the low memory mode code only 
>>>>> checks
>>>>> extent/chunk trees, file/subvolume trees are still checked by 
>>>>> original
>>>>> mode.
>>>>> 
>>>>> You could try the devel branch from David, which now contains the 
>>>>> full
>>>>> low memory mode check code:
>>>>> https://github.com/kdave/btrfs-progs/tree/devel
>>>>> 
>>>>> Although low memory mode doesn't support repair yet, it would give 
>>>>> us
>>>>> enough info on what's corrupted, so we can later fix it by hand or
>>>>> enhance original mode.
>>>>> 
>>>>> Thanks,
>>>>> Qu
>>>>> 
>>>>> At 10/24/2016 03:42 AM, none wrote:
>>>>> 
>>>>>> Hello,
>>>>>> I have the following bug
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=178781 in btrfs check, 
>>>>>> is
>>>>>> there a way to recover my filesystem in clean state without 
>>>>>> formatting
>>>>>> or using btrsfck ? Of course, the point is no longer need the 
>>>>>> files
>>>>>> which are damaged.
>>>>>> So is there a way to recover a btrfs filesystem by deleting the
>>>>>> corrupted data instead of trying to restore it ?
>>>>>> 
>>>>>> btrfs fi df /mnt/Opera_Mobile_Emulator_12.1_Linux
>>>>>> Data, single: total=66.01GiB, used=0.00B
>>>>>> System, DUP: total=8.00MiB, used=16.00KiB
>>>>>> System, single: total=4.00MiB, used=0.00B
>>>>>> Metadata, DUP: total=5.00GiB, used=28.00KiB
>>>>>> Metadata, single: total=8.00MiB, used=0.00B
>>>>>> GlobalReserve, single: total=4.00MiB, used=0.00B
>>>>>> 
>>>>>> btrfs progs version 4.7.3 from Devuan
>>>>>> 
>>>>>> Label: 'backup'  uuid: 56040bbb-ed5c-47f2-82e2-34457bd7b4f3
>>>>>> Total devices 1 FS bytes used 44.00KiB
>>>>>> devid    1 size 298.91GiB used 76.04GiB path
>>>>>> /dev/mapper/isw_bdffeeeijj_Volume0p7
>>>>>> 
>>>>>> uname -a
>>>>>> Linux localhost 4.5.0-0.bpo.1-amd64 #1 SMP Debian 4.5.1-1~bpo8+1
>>>>>> (2016-04-20) x86_64 GNU/Linux
>>>>>> 
>>>>>> Result of btrfs-image on /dev/mapper/isw_bdffeeeijj_Volume0p7 :
>>>>>> https://web.archive.org/web/20161020220914/https://filebin.net/7ni8kfpog1dxw4jc/btrfs-image_capture.xz
>>>>>> 
>>>>>> 
>>>>>> 
>>>>>> Thanks,
