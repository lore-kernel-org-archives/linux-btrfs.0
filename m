Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2L2L23 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 06:28:29 -0500
Message-ID: <50DED3D2.7010502@friedels.name>
Date: Sat, 29 Dec 2012 12:28:18 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: segmentation-fault in btrfsck (git-version)
References: <50BFB3B2.8040405@friedels.name> <CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com> <50C4E152.2000102@friedels.name> <CAKcLGm8wm1Gfe0ESCubGusqe_zojJp=7JORLXuq_EUdY22JOWA@mail.gmail.com> <50CCD247.3090701@friedels.name> <CAKcLGm-bwUriSBzoM2FTV9Rv1=dYp=5H_me8VZX6vygtXEhADg@mail.gmail.com> <50D0EB73.4090304@friedels.name>
In-Reply-To: <50D0EB73.4090304@friedels.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I re-send this message, hoping that someone can give me a hint?

Regards,
Hendrik

Am 18.12.2012 23:17, schrieb Hendrik Friedel:
> Hi Mitch, hi all,
>
> thanks for your hint.
>
> I used btrfs-debug-tree now.
> With -e, the output is empty. But without -e I do get a bit output file.
> When I search for Filenames that I am missing, I get:
>
> grep Sting big_output_file  |grep Berlin
>                  namelen 20 datalen 0 name: Sting_Live_in_Berlin
>                  namelen 20 datalen 0 name: Sting_Live_in_Berlin
>                  inode ref index 29 namelen 20 name: Sting_Live_in_Berlin
>
> That looks good.
> That raises two questions now: Can I restore the file?
> And: Can I do that for a whole Path (e.g. ./Video/)
>
> Greetings&Thanks!
> Hendrik
>
>
> Am 15.12.2012 23:24, schrieb Mitch Harder:
>> On Sat, Dec 15, 2012 at 1:40 PM, Hendrik Friedel
>> <hendrik@friedels.name> wrote:
>>> Hello Mitch, hello all,
>>>
>>>
>>>> Since btrfs has significant improvements and fixes in each kernel
>>>>
>>>> release, and since very few of these changes are backported, it is
>>>> recommended to use the latest kernels available.
>>>
>>>
>>> Ok, it's 3.7 now.
>>>
>>>
>>>> The "root ### inode ##### errors 400" are an indication that there is
>>>> an inconsistency in the inode size.  There was a patch included in the
>>>> 3.1 or 3.2 kernel to address this issue
>>>>
>>>> (http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=f70a9a6b94af86fca069a7552ab672c31b457786).
>>>>
>>>>    But I don't believe this patch fixed existing occurrences of this
>>>> error.
>>>
>>>
>>> Apparently not. It's still there.
>>>
>>>
>>>> At this point, the quickest solution for you may be to rebuild and
>>>> reformat this RAID assembly, and restore this data from backups.
>>>
>>>
>>> Yepp, I did that. But in fact, some data is missing. It is not
>>> essential,
>>> but nice to have.
>>>
>>>
>>>> If you don't have a backup of this data, and since your array seems to
>>>> be working pretty well in a degraded state, this would be a really
>>>> good time to look at a strategy of getting a backup of this data
>>>> before doing many more attempts at rescue.
>>>
>>>
>>> Done. It's all save on another ext4 drive.
>>>
>>> So, let's play ;-)
>>> Could you please help me trying to restore the missing Data?
>>>
>>> What I tried sofar was:
>>> ./btrfs-restore /dev/sdc1 /mnt/restore/
>>>
>>> It worked, in a way that it restored what I already had.
>>> What's odd aswell is, that btrfs scrub did run through without errors.
>>> So, the missing data could have been (accidentally) deleted by me. But I
>>> don't think... nevertheless I cannot exclude.
>>>
>>> What I know is the (original) Path of the Data.
>>>
>>
>> You could try btrfs-debug-tree, and search for any traces of your
>> file.  However, be ready to sift through a massive amount of output.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
