Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33875 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbcAKXEF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 18:04:05 -0500
Received: by mail-wm0-f54.google.com with SMTP id u188so233953609wmu.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 15:04:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZDa6yJJyu5fsyscJ_v7D7s-bjcvo1WDLp4jqqHFO=0xA@mail.gmail.com>
References: <CA+9GZUitvMjJSgdpmMb8Fsz-CHK4WXV9XVhGCk9mRCWUU_D-VQ@mail.gmail.com>
 <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CAPmG0jYaga9c0+x+TzdR_FuV57qfr2M-topeRstazV9n1=f9sQ@mail.gmail.com>
 <CA+9GZUg752dgd2mpEiBvHrFr3W_zccwk4yN=e04DN0OPTBrGDg@mail.gmail.com> <CAPmG0jZDa6yJJyu5fsyscJ_v7D7s-bjcvo1WDLp4jqqHFO=0xA@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Tue, 12 Jan 2016 00:03:43 +0100
Message-ID: <CA+9GZUgE5J8=ZLFiLEOAsxsUdDz8DJCK6gmoR49VtHJ=UkpYoA@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Henk Slager <eye1tm@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 8:50 PM, Henk Slager <eye1tm@gmail.com> wrote:
> On Mon, Jan 11, 2016 at 12:47 AM, cheater00 . <cheater00@gmail.com> wrote:
>> On Sun, Jan 10, 2016 at 3:14 PM, Henk Slager <eye1tm@gmail.com> wrote:
>>> On Sat, Jan 9, 2016 at 9:26 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>> On Sat, Jan 09, 2016 at 09:00:47PM +0100, cheater00 . wrote:
>>>>> Hello,
>>>>> I can repeatedly trigger this bug by making the "data" portion fill
>>>>> up. If you remember the partition is 6 TB but in btrfs filesystem df
>>>>> Data is shown as only 2TB when in fact it should be nearly 6TB. So
>>>>> this has nothing to do with kernel bugs. The filesystem on disk is
>>>>> structured incorrectly. How do i fix this? How do I make "Data"
>>>>> bigger? What is it exactly?
>>>>
>>>>    This is *exactly* the behaviour of the known kernel bug. The bug is
>>>> that the FS *should* be extending the data allocation when it gets
>>>> near to full, and it's not. There is no way of manually allocating
>>>> more (because the FS should be doing it automatically). There is no
>>>> known way of persuading the FS to it when it isn't.
>>>
>>> Probably this is 'the'  bug we talk about:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=74101
>>
>> Yes, would seem like it.
>>
>>> Size of the fs is much smaller, but also problem occurs when fill-level is <50%
>>>
>>> btrfs fs resize  did nothing you mention, but AFAIK you should see
>>> something in dmesg when you do that.
>>
>>
>> I remounted (to make the filesystem rw again) and got the attached
>> log. There are some errors in there. But bear in mind that this disk
>> has been hanging on in ro mode for a few days now.
>>
>> I did this:
>> # btrfs fi resize -1T Media
>> Resize 'Media' of '-1T'
>> # btrfs filesystem resize -1G Media
>> Resize 'Media' of '-1G'
>> # btrfs filesystem resize -1T Media
>> Resize 'Media' of '-1T'
>> # btrfs filesystem resize max Media
>> Resize 'Media' of 'max'
>>
>> and it resulted in the following lines in dmesg:
>> [189115.919160] BTRFS: new size for /dev/sdc1 is 4901661835264
>> [189177.306291] BTRFS: new size for /dev/sdc1 is 4900588093440
>> [189181.950289] BTRFS: new size for /dev/sdc1 is 3801076465664
>> [189232.064357] BTRFS: new size for /dev/sdc1 is 6001173463040
>>
>> (note the device changed from sdd to sdc when I rebooted last)
>>
>>> And what is the output of   gdisk -l /dev/sdd  , just to check?
>>
>> (the device changed to sdc since I've rebooted)
>>
>> # gdisk -l /dev/sdc
>> GPT fdisk (gdisk) version 0.8.8
>>
>> Partition table scan:
>>   MBR: protective
>>   BSD: not present
>>   APM: not present
>>   GPT: present
>>
>> Found valid GPT with protective MBR; using GPT.
>> Disk /dev/sdc: 11721045168 sectors, 5.5 TiB
>> Logical sector size: 512 bytes
>> Disk identifier (GUID): 0DEF5509-8730-4AB4-A846-79DA3C376F66
>> Partition table holds up to 128 entries
>> First usable sector is 34, last usable sector is 11721045134
>> Partitions will be aligned on 2048-sector boundaries
>> Total free space is 3181 sectors (1.6 MiB)
>>
>> Number  Start (sector)    End (sector)  Size       Code  Name
>>    1            2048     11721043967   5.5 TiB     8300
>>
>>
>>> Have you had the fs already filled up to e.g. 95% before or has is
>>> always been not more than 2TiB?
>>
>> It has never been more than 2TB, I've had it for quite some time now
>> but it's always hovered around 1TB.
>>
>>> Why are the single (empty )profiles for metadata and system still
>>> there?  They should have been removed already by the various balancing
>>> operations that are advised in the btrfs-wiki.
>>
>> Not sure. Would this happen automatically? Or is this something I
>> should have done?
>> I have another fs on the same model/size disk, which isn't exhibiting
>> this bug, and it has those profiles as well.
>
> There is nothing really wrong (just by quickly browsing the numbers)
> as far as I can see. So it seems the 'btrfs space allocation
> mechanism' somehow gives up under certain circumstances.

Can we somehow make this thing tell us what it's doing and why it's
breaking? Some sort of debug log on when things are being allocated?

> The fs was
> created by bit older tools/kernel, that is why these dummy single
> chunks are there. They should not harm, but at least a full balance
> will remove them. Also a parttial balance -musage=0 with latest tools
> should also remove them, i don't remember exactly. If they are not
> needed, keep the fs as simple as possible and remove them I would say.
> I was just wondering what balancing options you have tried.

That's one thing to try.

>>> What you could try is to create an image+'copy' of the fs with
>>> btrfs-image just after you get ENOSPC abd then do various tests with
>>> that (make sure unmount or even better unplug the physical hdd!). Like
>>> mounting and then try to add a file, convert all metadata + system
>>> from dup to single and then try to add a file. It all doesn't give
>>> real space, but it might give hints to what could be wrong.
>>
>> I can't do that because I would have to buy an extra disk which is 300 euro.
>
> btrfs-image only images/dumps the metadata. In your case it is ~6GiB.
> # umount /dev/sdc1
> # cd /sparse-file-featured-fs-mount/
> # btrfs-image /dev/sdc1 Mediafs.metadump
> # btrfs-image -r Mediafs.metadump Mediafs.img
> # losetup -f /Mediafs.img
> # mount /dev/loopX /mnt
> # dd if=/dev/zero of=/mnt/testfile bs=1M count=5000
>
> The file Mediafs.img is initially using ~6GiB space, its reported size
> is same as real partition on the harddisk. The dd command increases it
> with 5GB and simulates a large file copy. So you need upto 10's of GBs
> freespace to do this tests, fast SSD preferred. You can also copy some
> real files and see if you hit ENOSPC.
>
> If the test is on btrfs, you can easily snapshot or copy--reflink the
> original Mediafs.img and try various metadata balancing. And use the
> btrfs compression.

That's another thing to try, thanks. This seems very manageable.

>>> If you somehow manage to reduce the fs by lets say 100G and also the
>>> partition, you could install or copy a newer linux+kernel to
>>> partition(s) in that 100G space and boot from there.
>>
>> let me try finding the latest kernel then. There are backports.
> As suggested earlier, try kernel 4.4 (released today). People have
> reported that they weren't bugged anymore by ENOSPC aborts after
> switching from some older kernel.

I'll see if I can get a hold of this for my version of Ubuntu. This
will be the first thing I'll try. Then I'll try the imaging, and then
the rebalancing on the image.
