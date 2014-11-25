Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:51498 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaKYHmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 02:42:32 -0500
Received: by mail-oi0-f41.google.com with SMTP id a3so28141oib.14
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 23:42:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54742F42.2050202@cn.fujitsu.com>
References: <CAPRQymMYBhy0mxG1qTxqt2OGezm3qnq+rAZOLAk1TpkOoixNWw@mail.gmail.com>
 <54740F42.2040301@cn.fujitsu.com> <CAPRQymNp3+387P-nmXKoWGNV31TKaYLBWv6g63WwJPqN4g-fYg@mail.gmail.com>
 <547411B3.2040309@cn.fujitsu.com> <CAPRQymO3rODHMw+=BzURdOYfxGUshCrt48LY4gWT7g=Yd=z8jg@mail.gmail.com>
 <54742F42.2050202@cn.fujitsu.com>
From: Daniel Miranda <danielkza2@gmail.com>
Date: Tue, 25 Nov 2014 05:42:12 -0200
Message-ID: <CAPRQymN4zKWcnFGTziEExg62c6_qQx7kYyjw08ZUvt+fdp3qKQ@mail.gmail.com>
Subject: Re: Apparent metadata corruption (file that simultaneously does/does
 not exist) on kernel 3.17.3
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just ran the repair but the ghost file has not disappeared, unfortunately.

On Tue, Nov 25, 2014 at 5:26 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
> -------- Original Message --------
> Subject: Re: Apparent metadata corruption (file that simultaneously
> does/does not exist) on kernel 3.17.3
> From: Daniel Miranda <danielkza2@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年11月25日 15:20
>>
>> Here are the logs. I'll send you a link to my dump directly after I
>> finish uploading it. Please notify me when you have downloaded it so I
>> can delete it.
>>
>> checking extents
>> checking free space cache
>> checking fs roots
>> root 5 inode 17149868 errors 2000, link count wrong
>>      unresolved ref dir 17182377 index 245 namelen 8 name string.h
>> filetype 1 errors 1, no dir item
>
> link count error seems resolved by Josef's patch commit already in 3.17.2.
> If using 3.17.2, josef's commit will rebuild the dir item and dir index.
>>
>> root 5 inode 17182377 errors 200, dir isize wrong
>
> This isize error seems caused by previous line.
> If 3.17.2 can repair above problem, it should not be a problem and will
> disappear.
>
> According to the above output, btrfsck --repair with btrfs-progs 3.17.2 has
> a good chance repairing it.
> Just have a try.
>
> Thanks,
> Qu
>
>> Checking filesystem on /dev/mapper/fedora_daniel--pc-root
>> UUID: fef8f718-0622-4cb1-9597-749650d366a4
>> found 55108022156 bytes used err is 1
>> total csum bytes: 89787396
>> total tree bytes: 2303455232
>> total fs tree bytes: 2024841216
>> total extent tree bytes: 145272832
>> btree space waste bytes: 529672422
>> file data blocks allocated: 253414481920
>>   referenced 94127726592
>> Btrfs v3.17
>>
>>
>> Regards,
>> Daniel
>>
>> On Tue, Nov 25, 2014 at 3:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> -------- Original Message --------
>>> Subject: Re: Apparent metadata corruption (file that simultaneously
>>> does/does not exist) on kernel 3.17.3
>>> From: Daniel Miranda <danielkza2@gmail.com>
>>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> Date: 2014年11月25日 13:14
>>>>
>>>> I'll go run that and get you the output.
>>>
>>> Thanks.
>>>>
>>>>
>>>> I can do the image dump, sure. I don't know how long it might take to
>>>> upload it somewhere though. Right now `btrfs fi df` shows about 2GiB
>>>> of metadata (it's a 120GiB volume). I'll see how large it ends up
>>>> after compression.
>>>
>>> 120G volume seems quite small, compared the images I received recently
>>> (1T
>>> x2 RAID1 and 4T single).
>>> With '-c 9' it shouldn't be too huge I think(The 1T raid1 is about 1G
>>> metadata with -c9).
>>>
>>> BTW, btrfs-image dump will have all the filenames and hierarchy, even
>>> without its data,
>>> it is still better considering your privacy twice before uploading.
>>>
>>> Thanks,
>>> Qu
>>>
>>>> Thanks for the quick response,
>>>> Daniel
>>>>
>>>> On Tue, Nov 25, 2014 at 3:10 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> What's the btrfsck output? Without --repair option.
>>>>>
>>>>> Also, if it is OK for you, would you please dump the btrfs with
>>>>> 'btrfs-image' command?
>>>>> '-c 9' option is highly recommended considering the size of it.
>>>>> This will helps a lot for developers to test the btrfsck repair
>>>>> function.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>> -------- Original Message --------
>>>>> Subject: Apparent metadata corruption (file that simultaneously
>>>>> does/does
>>>>> not exist) on kernel 3.17.3
>>>>> From: Daniel Miranda <danielkza2@gmail.com>
>>>>> To: <linux-btrfs@vger.kernel.org>
>>>>> Date: 2014年11月25日 13:04
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> After I had some brief stability issues with my computer, it seems
>>>>>> some form of metadata corruption took place in my BTRFS filesystem,
>>>>>> and now a particular file seems to exist, but I cannot access any
>>>>>> details on it or delete it.
>>>>>>
>>>>>> If I try to `ls` in the directory it is in, that's what I get:
>>>>>>
>>>>>> ls: cannot access string.h: No such file or directory
>>>>>> total 0
>>>>>> drwxr-xr-x. 1 danielkza mock 16 Nov 21 14:18 ./
>>>>>> drwxr-xr-x. 1 danielkza mock  6 Nov 21 14:18 ../
>>>>>> -?????????? ? ?         ?     ?            ? string.h
>>>>>>
>>>>>> If I try to delete it I get:
>>>>>>
>>>>>> rm: cannot remove ‘string.h’: No such file or directory
>>>>>>
>>>>>> I'm using kernel 3.17.3 from Fedora 21. I got no messages on dmesg or
>>>>>> anything of the sort. I know the btrfs fsck situation is complicated,
>>>>>> but is there any utility I should use to try and repair this? Losing
>>>>>> this file is not a problem, it's just one header from the kernel I was
>>>>>> building.
>>>>>>
>>>>>> Regards,
>>>>>> Daniel Miranda
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>
