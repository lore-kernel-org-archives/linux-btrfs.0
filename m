Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34051 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934380AbcAZMAZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 07:00:25 -0500
Received: by mail-io0-f177.google.com with SMTP id 1so182642485ion.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 04:00:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYKk14M8JoP5OLkxj0p169uKAyXexERtV_yPhgq1KUwK_A@mail.gmail.com>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
 <CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
 <CAAcrkY+3w--OGYWwben+KYohdqwBBryDn8REJ6tiBk4jM3Tp9w@mail.gmail.com>
 <CAA7pwKP6KXHHkp4pALjbxqOFT2ve5T8r0RNcbmdVWXqLmveDgg@mail.gmail.com>
 <CAAcrkYJKoooUWOOsbqXot=U4voe+V_8iMf1NODbjUqMdn6g0Hg@mail.gmail.com>
 <CAPmG0jahDyaHhh1dZxS_L=0C27R_4GWtZeaGTrL50Gze4BRtKg@mail.gmail.com>
 <CAAcrkY+a0+KFU5=TyozdAbOoqC4KN8U94YphUvKV+etvGiE_+w@mail.gmail.com>
 <CAAcrkYK7p1kFNS_p7s12Qv3Hafemq89hgocfa+DoX6Y15bXeBA@mail.gmail.com> <CAAcrkYKk14M8JoP5OLkxj0p169uKAyXexERtV_yPhgq1KUwK_A@mail.gmail.com>
From: John Smith <lenovomi@gmail.com>
Date: Tue, 26 Jan 2016 12:59:55 +0100
Message-ID: <CAAcrkY+huzf1vcm6gNLWgJE1df=oZ9+o6_o7VAZEGoSZRoVJ3Q@mail.gmail.com>
Subject: Re: uknown issues - different sha256 hash - files corruption
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To previous email:

Also I copied out from LVM  to btrfs almost 2TB of small file and all
hashes are same.

Here is full output of cmp -l file_on_lvm file_on_btrfs

https://drive.google.com/file/d/0B6RZ_9vVuTEcQ3RUSV9hdXU3eUE/view?usp=sharing


On Tue, Jan 26, 2016 at 12:58 PM, John Smith <lenovomi@gmail.com> wrote:
> The results of the cmp are here:
> https://drive.google.com/file/d/0B6RZ_9vVuTEcQ3RUSV9hdXU3eUE/view?usp=sharing
>
> On Tue, Jan 26, 2016 at 2:00 AM, John Smith <lenovomi@gmail.com> wrote:
>> Also I copied out from LVM  to btrfs almost 2TB of small file and all
>> hashes are same.
>>
>> Here is full output of cmp -l file_on_lvm file_on_btrfs
>>
>> https://drive.google.com/open?id=0B6RZ_9vVuTEcQ3RUSV9hdXU3eUE
>>
>>
>>
>>
>> On Tue, Jan 26, 2016 at 1:15 AM, John Smith <lenovomi@gmail.com> wrote:
>>> Hello,
>>>
>>> i copied data from to btrfs (same file) and the hashes are same. Also
>>> btrfs to lvm was okay.
>>>
>>> Still waiting for the results of lvm to lvm.
>>>
>>> At the moment i dont have any box around that i can use to replace cuboxi.
>>>
>>> Could it be really HW problem? As you can see data between btrfs to
>>> btrfs was  copied w/out any issues. Problem is looks like only between
>>> lvm to btrfs. Im so confused.
>>>
>>> On Mon, Jan 25, 2016 at 11:02 PM, Henk Slager <eye1tm@gmail.com> wrote:
>>>> On Mon, Jan 25, 2016 at 5:53 PM, John Smith <lenovomi@gmail.com> wrote:
>>>>> Hello all,
>>>>>
>>>>> there is no network involvement in that copy process. Esata enclosure
>>>>> is attached directly to cuboxi and copy is between 2 sata drives in
>>>>> lvm (using ext4) and two btrfs drives in raid1.
>>>>
>>>> I thought it was raid0, anyhow it seems not relevant, it just a btrfs filesystem
>>>>
>>>>> When i copy data from lvm to btrfs, hash of the file on btrfs is
>>>>> different compare to the one on lvm. When I copy exactly same file
>>>>> multiple times all the time it got different hash on btrfs.
>>>>>
>>>>> I did a test, i copied file from btrfs to lvm and both hashes are same.
>>>>>
>>>>>
>>>>> When can intervent / mess up data when i do copy between lvm to btrfs?
>>>>
>>>> My first thought was that it could due to that you are using SATA port
>>>> multiplexing. But then you would likely experience some corruption of
>>>> the btrfs fs, although it might take some time (days/weeks) before you
>>>> discover. You could check dmesg to see what is there for ataX.Y.
>>>> A mitigation would be to do the same copy tests over USB, although
>>>> port-multiplexing might still be effective, I don't know that.
>>>>
>>>> It could also be that the cubox with its current firmware+software
>>>> fails under certain loads (btrfs writing is quite different from
>>>> ext4), it might be that it is just your cubox hardware, maybe power
>>>> issues or whatever. Or some btrfs/other piece of code overwrites the
>>>> rsync/btrfs write buffers before crc every now and then. Or just
>>>> memory errors as already suggested.
>>>>
>>>>>
>>>>> All drives are brand new, badblocks was executed on each drive, also
>>>>> smart doesnt shows up any issues.
>>>>
>>>> The drives are not the issue I think. I would temporary replace the
>>>> cubox with a typical x86_64 system with kernel v4.4 from kernel.org,
>>>> connect the icy box via eSATA port (or USB if you don't have) and
>>>> execute the copy tests lvm -> btrfs. From there you can see if it is
>>>> btrfs on the cubox and maybe then just connect a single SATA disk to
>>>> the cubox and repeat tests and maybe try a bit older kernel (like
>>>> 3.18) as well.
>>>>
>>>> And what if you do If this several times on cubox and PC?
>>>> # dd if=/dev/zero of=<fileonbtrfs> bs=1M count=130000
>>>>
>>>>> thank you
>>>>>
>>>>> On Mon, Jan 25, 2016 at 10:03 AM, Patrik Lundquist
>>>>> <patrik.lundquist@gmail.com> wrote:
>>>>>> On 25 January 2016 at 01:12, John Smith <lenovomi@gmail.com> wrote:
>>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> what else/ or where it was corrupted?
>>>>>>
>>>>>> It got corrupted after leaving the source disk and before btrfs
>>>>>> calculated the data checksum during file write.
>>>>>>
>>>>>>
>>>>>>> I didnt check data checksum
>>>>>>> errors - is it possible with some btrfs tools? But yes I can read
>>>>>>> whole file after stored on btrfs.
>>>>>>
>>>>>> You wouldn't have been able to read the whole corrupted file from
>>>>>> btrfs if the corruption took place after the file was written (due to
>>>>>> wrong checksum).
>>>>>>
>>>>>>
>>>>>>> By checksum errors, do you mean sha256 hash?
>>>>>>
>>>>>> No, I mean the built-in data checksum in btrfs that guarantees file integrity.
>>>>>>
>>>>>>
>>>>>>> I plan to run memcheck but on the irc i was suggested that it is not
>>>>>>> RAM issue, based on the output from the cmp.
>>>>>>
>>>>>> Perhaps not, but you have to rule that out. Leave the memtest overnight.
>>>>>>
>>>>>>
>>>>>>> The drives are brand new
>>>>>>> and badblocks + smart test was executed with no errors.
>>>>>>
>>>>>> That's great.
>>>>>>
>>>>>>
>>>>>>> On Mon, Jan 25, 2016 at 1:06 AM, Patrik Lundquist
>>>>>>> <patrik.lundquist@gmail.com> wrote:
>>>>>>> > On 24 January 2016 at 23:00, John Smith <lenovomi@gmail.com> wrote:
>>>>>>> >>
>>>>>>> >> Dear,
>>>>>>> >>
>>>>>>> >> I have cubox-i4, running debian with 4.4 kernel. The icy box
>>>>>>> >> IB-3664SU3 enclosure is attached into cubox using esata port,
>>>>>>> >> enclosure uses JM393 and JM539 chipsets.
>>>>>>> >>
>>>>>>> >> I use btrfs volume in raid0 created from the two drives, and lvm ext4
>>>>>>> >> volume that contains two drives also. When I copy (using rsync) big
>>>>>>> >> file (the one i copied is 130GB) from ext4 to btrfs the sha256 hash is
>>>>>>> >> differs.
>>>>>>> >>
>>>>>>> >> I did 2 tests, copy the source file from ext4 to btrfs, count sha256
>>>>>>> >> hash, each time the destination file on btrfs has different hash
>>>>>>> >> compared to the source file located on ext4 and even hashes from both
>>>>>>> >> runs of target files on btrfs differs.
>>>>>>> >>
>>>>>>> >> I run cmp -l <(hexdump source_file_ext4) <(hexdump target_file_btrfs).
>>>>>>> >> The snapshot of the result is here http://paste.debian.net/367678/,
>>>>>>> >> the is so many bytes with differences. The size of the source and
>>>>>>> >> target file is exactly the same.
>>>>>>> >>
>>>>>>> >>
>>>>>>> >> I also copied around 600GB of data set that contains small files,
>>>>>>> >> music, videos, etc... and i did sha256 on all the files ext4 vs btrfs
>>>>>>> >> - all was fine.
>>>>>>> >>
>>>>>>> >> Any idea what can cause that issue or how can i debug it in more detail?
>>>>>>> >
>>>>>>> > The data must have become corrupted before it was written to the btrfs
>>>>>>> > volume, since you can read it back without data checksum errors.
>>>>>>> >
>>>>>>> > Try copying the big file a couple of times but from btrfs to ext4 to
>>>>>>> > see if you get data checksum errors.
>>>>>>> >
>>>>>>> > Run memcheck and long SMART tests on the disks.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
