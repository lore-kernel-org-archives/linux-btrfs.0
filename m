Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55903 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbcDCB0c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Apr 2016 21:26:32 -0400
Subject: Re: scrub: Tree block spanning stripes, ignored
To: Ivan P <chrnosphered@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <CADzmB21iEn03C5rtP=4dGe3mS8Tvd_+VUDLtczUQMotPcDOPNg@mail.gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <570070D4.80404@gmx.com>
Date: Sun, 3 Apr 2016 09:24:36 +0800
MIME-Version: 1.0
In-Reply-To: <CADzmB21iEn03C5rtP=4dGe3mS8Tvd_+VUDLtczUQMotPcDOPNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/03/2016 12:29 AM, Ivan P wrote:
> It's about 800Mb, I think I could upload that.
>
> I ran it with the -s parameter, is that enough to remove all personal
> info from the image?
> Also, I had to run it with -w because otherwise it died on the same
> corrupt node.

You can also use -c9 to further compress the data.

Thanks,
Qu
>
> On Fri, Apr 1, 2016 at 2:25 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Ivan P wrote on 2016/03/31 18:04 +0200:
>>>
>>> Ok, it will take a while until I can attempt repairing it, since I
>>> will have to order a spare HDD to copy the data to.
>>> Should I take some sort of debug snapshot of the fs so you can take a
>>> look at it? I think I read something about a snapshot that only
>>> contains the fs but not the data that somewhere.
>>
>> That's btrfs-image.
>>
>> It would be good, but if your metadata is over 3G, I think it's would take a
>> lot of time uploading.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Regards,
>>> Ivan.
>>>
>>> On Tue, Mar 29, 2016 at 3:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> Ivan P wrote on 2016/03/28 23:21 +0200:
>>>>>
>>>>>
>>>>> Well, the file in this inode is fine, I was able to copy it off the
>>>>> disk. However, rm-ing the file causes a segmentation fault. Shortly
>>>>> after that, I get a kernel oops. Same thing happens if I attempt to
>>>>> re-run scrub.
>>>>>
>>>>> How can I delete that inode? Could deleting it destroy the filesystem
>>>>> beyond repair?
>>>>
>>>>
>>>>
>>>> The kernel oops should protect you from completely destroying the fs.
>>>>
>>>> However it seems that the problem is beyond kernel's handle (kernel
>>>> oops).
>>>>
>>>> So no safe recovery method now.
>>>>
>>>>   From now on, any repair advice from me *MAY* *destroy* your fs.
>>>> So please do backup when you still can.
>>>>
>>>>
>>>> The best possible try would be "btrfsck --init-extent-tree --repair".
>>>>
>>>> If it works, then mount it and run "btrfs balance start <mnt>".
>>>> Lastly, umount and use btrfsck to re-check if it fixes the problem.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>>
>>>>> Regards,
>>>>> Ivan
>>>>>
>>>>> On Mon, Mar 28, 2016 at 3:10 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Ivan P wrote on 2016/03/27 16:31 +0200:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Thanks for the reply,
>>>>>>>
>>>>>>> the raid1 array was created from scratch, so not converted from ext*.
>>>>>>> I used btrfs-progs version 4.2.3 on kernel 4.2.5 to create the array,
>>>>>>> btw.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> I don't remember any strange behavior after 4.0, so no clue here.
>>>>>>
>>>>>> Go to the subvolume 5 (the top-level subvolume), find inode 71723 and
>>>>>> try
>>>>>> to
>>>>>> remove it.
>>>>>> Then, use 'btrfs filesystem sync <mount point>' to sync the inode
>>>>>> removal.
>>>>>>
>>>>>> Finally use latest btrfs-progs to check if the problem disappears.
>>>>>>
>>>>>> This problem seems to be quite strange, so I can't locate the root
>>>>>> cause,
>>>>>> but try to remove the file and hopes kernel can handle it.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Is there a way to fix the current situation without taking the whole
>>>>>>> data off the disk?
>>>>>>> I'm not familiar with file systems terms, so what exactly could I have
>>>>>>> lost, if anything?
>>>>>>>
>>>>>>> Regards,
>>>>>>> Ivan
>>>>>>>
>>>>>>> On Sun, Mar 27, 2016 at 4:23 PM, Qu Wenruo <quwenruo.btrfs@gmx.com
>>>>>>> <mailto:quwenruo.btrfs@gmx.com>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>        On 03/27/2016 05:54 PM, Ivan P wrote:
>>>>>>>
>>>>>>>            Read the info on the wiki, here's the rest of the requested
>>>>>>>            information:
>>>>>>>
>>>>>>>            # uname -r
>>>>>>>            4.4.5-1-ARCH
>>>>>>>
>>>>>>>            # btrfs fi show
>>>>>>>            Label: 'ArchVault'  uuid:
>>>>>>> cd8a92b6-c5b5-4b19-b5e6-a839828d12d8
>>>>>>>                     Total devices 1 FS bytes used 2.10GiB
>>>>>>>                     devid    1 size 14.92GiB used 4.02GiB path
>>>>>>> /dev/sdc1
>>>>>>>
>>>>>>>            Label: 'Vault'  uuid: 013cda95-8aab-4cb2-acdd-2f0f78036e02
>>>>>>>                     Total devices 2 FS bytes used 800.72GiB
>>>>>>>                     devid    1 size 931.51GiB used 808.01GiB path
>>>>>>> /dev/sda
>>>>>>>                     devid    2 size 931.51GiB used 808.01GiB path
>>>>>>> /dev/sdb
>>>>>>>
>>>>>>>            # btrfs fi df /mnt/vault/
>>>>>>>            Data, RAID1: total=806.00GiB, used=799.81GiB
>>>>>>>            System, RAID1: total=8.00MiB, used=128.00KiB
>>>>>>>            Metadata, RAID1: total=2.00GiB, used=936.20MiB
>>>>>>>            GlobalReserve, single: total=320.00MiB, used=0.00B
>>>>>>>
>>>>>>>            On Fri, Mar 25, 2016 at 3:16 PM, Ivan P
>>>>>>> <chrnosphered@gmail.com
>>>>>>>            <mailto:chrnosphered@gmail.com>> wrote:
>>>>>>>
>>>>>>>                Hello,
>>>>>>>
>>>>>>>                using kernel  4.4.5 and btrfs-progs 4.4.1, I today ran a
>>>>>>>                scrub on my
>>>>>>>                2x1Tb btrfs raid1 array and it finished with 36
>>>>>>>                unrecoverable errors
>>>>>>>                [1], all blaming the treeblock 741942071296. Running
>>>>>>> "btrfs
>>>>>>>                check
>>>>>>>                --readonly" on one of the devices lists that extent as
>>>>>>>                corrupted [2].
>>>>>>>
>>>>>>>                How can I recover, how much did I really lose, and how
>>>>>>> can
>>>>>>> I
>>>>>>>                prevent
>>>>>>>                it from happening again?
>>>>>>>                If you need me to provide more info, do tell.
>>>>>>>
>>>>>>>                [1] http://cwillu.com:8080/188.110.141.36/1
>>>>>>>
>>>>>>>
>>>>>>>        This message itself is normal, it just means a tree block is
>>>>>>>        crossing 64K stripe boundary.
>>>>>>>        And due to scrub limit, it can check if it's good or bad.
>>>>>>>        But....
>>>>>>>
>>>>>>>                [2] http://pastebin.com/xA5zezqw
>>>>>>>
>>>>>>>        This one is much more meaningful, showing several strange bugs.
>>>>>>>
>>>>>>>        1. corrupt extent record: key 741942071296 168 1114112
>>>>>>>        This means, this is a EXTENT_ITEM(168), and according to the
>>>>>>> offset,
>>>>>>>        it means the length of the extent is, 1088K, definitely not a
>>>>>>> valid
>>>>>>>        tree block size.
>>>>>>>
>>>>>>>        But according to [1], kernel think it's a tree block, which is
>>>>>>> quite
>>>>>>>        strange.
>>>>>>>        Normally, such mismatch only happens in fs converted from ext*.
>>>>>>>
>>>>>>>        2. Backref 741942071296 root 5 owner 71723 offset 2589392896
>>>>>>>        num_refs 0 not found in extent tree
>>>>>>>
>>>>>>>        num_refs 0, this is also strange, normal backref won't have a
>>>>>>> zero
>>>>>>>        refrence number.
>>>>>>>
>>>>>>>        3. bad metadata [741942071296, 741943185408) crossing stripe
>>>>>>> boundary
>>>>>>>        It could be a false warning fixed in latest btrfsck.
>>>>>>>        But you're using 4.4.1, so I think that's the problem.
>>>>>>>
>>>>>>>        4. bad extent [741942071296, 741943185408), type mismatch with
>>>>>>> chunk
>>>>>>>        This seems to explain the problem, a data extent appears in a
>>>>>>>        metadata chunk.
>>>>>>>        It seems that you're really using converted btrfs.
>>>>>>>
>>>>>>>        If so, just roll it back to ext*. Current btrfs-convert has
>>>>>>> known
>>>>>>>        bug but fix is still under review.
>>>>>>>
>>>>>>>        If want to use btrfs, use a newly created one instead of
>>>>>>> btrfs-convert.
>>>>>>>
>>>>>>>        Thanks,
>>>>>>>        Qu
>>>>>>>
>>>>>>>
>>>>>>>                Regards,
>>>>>>>                Soukyuu
>>>>>>>
>>>>>>>                P.S.: please add me to CC when replying as I did not
>>>>>>>                subscribe to the
>>>>>>>                mailing list. Majordomo won't let me use my hotmail
>>>>>>> address
>>>>>>>                and I
>>>>>>>                don't want that much traffic on this address.
>>>>>>>
>>>>>>>            --
>>>>>>>            To unsubscribe from this list: send the line "unsubscribe
>>>>>>>            linux-btrfs" in
>>>>>>>            the body of a message to majordomo@vger.kernel.org
>>>>>>>            <mailto:majordomo@vger.kernel.org>
>>>>>>>            More majordomo info at
>>>>>>> http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>>
>>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
