Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37053 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbcAKHzQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 02:55:16 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so254422161wmf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Jan 2016 23:55:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+9GZUgKoyanUUBzLqgghnK-vJD_8jFRnW13iEAHqzDS2NXNyA@mail.gmail.com>
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
 <CA+9GZUg752dgd2mpEiBvHrFr3W_zccwk4yN=e04DN0OPTBrGDg@mail.gmail.com>
 <CAJCQCtSuCj2tWfgKaGOYRP57LURaQv4jXdkJW6cjqjdVEvHTxw@mail.gmail.com>
 <CA+9GZUi5vYqx7+QaU8uuCB7bBhx+mfM_RJP0S6eDN8ZCJf0wYg@mail.gmail.com> <CA+9GZUgKoyanUUBzLqgghnK-vJD_8jFRnW13iEAHqzDS2NXNyA@mail.gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Mon, 11 Jan 2016 08:54:55 +0100
Message-ID: <CA+9GZUgzToyc7YqoPSbJQ2f=YSCkYf81+N2oTzYWM6m95uzCKw@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Chris Murphy <lists@colorremedies.com>
Cc: Henk Slager <eye1tm@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the fsck, the Data segment is being resized correctly. It would
seem to me that the fact Data was 2TB when this bug transpired was
just a coincidence.

Perhaps this line:
"BTRFS info (device sdc1): The free space cache file (2159324168192)
is invalid. skip it"

should not be "info" but an error, and should instruct the user to
fsck the file system.

I have requested an account on the btrfs wiki in order to add this info to:
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

On Mon, Jan 11, 2016 at 7:24 AM, cheater00 . <cheater00@gmail.com> wrote:
> When re-mounting now, this line was not present any more in dmesg:
> "BTRFS info (device sdc1): The free space cache file (2159324168192)
> is invalid. skip it"
>
> dmesg only showed:
> "[216798.144518] BTRFS info (device sdc1): disk space caching is enabled"
>
> On Mon, Jan 11, 2016 at 7:07 AM, cheater00 . <cheater00@gmail.com> wrote:
>> Here is the fsck log:
>>
>> # btrfs check /dev/sdc1
>> Checking filesystem on /dev/sdc1
>> UUID: b397b7ef-6754-4ba4-8b1a-fbf235aa1cf8
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 2178647877626 bytes used err is 0
>> total csum bytes: 2123923832
>> total tree bytes: 3749871616
>> total fs tree bytes: 645742592
>> total extent tree bytes: 680394752
>> btree space waste bytes: 284237552
>> file data blocks allocated: 2178788139008
>>  referenced 2173089497088
>> btrfs-progs v4.2.1
>>
>> On Mon, Jan 11, 2016 at 1:24 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>> On Sun, Jan 10, 2016 at 4:47 PM, cheater00 . <cheater00@gmail.com> wrote:
>>>> On Sun, Jan 10, 2016 at 3:14 PM, Henk Slager <eye1tm@gmail.com> wrote:
>>>
>>>> buggy fs ("Media"):
>>>> Data, single: total=1.98TiB, used=1.98TiB
>>>> System, DUP: total=8.00MiB, used=240.00KiB
>>>> System, single: total=4.00MiB, used=0.00B
>>>> Metadata, DUP: total=5.50GiB, used=3.49GiB
>>>> Metadata, single: total=8.00MiB, used=0.00B
>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>
>>>>> What you could try is to create an image+'copy' of the fs with
>>>>> btrfs-image just after you get ENOSPC abd then do various tests with
>>>>> that (make sure unmount or even better unplug the physical hdd!). Like
>>>>> mounting and then try to add a file, convert all metadata + system
>>>>> from dup to single and then try to add a file. It all doesn't give
>>>>> real space, but it might give hints to what could be wrong.
>>>>
>>>> I can't do that because I would have to buy an extra disk which is 300 euro.
>>>
>>> You have 4TB unused on that disk. You could shrink the fs to ~3TB, and
>>> then change partition size to match and create a 2nd partition with
>>> whatever FS you want as the target for btrfs-image.
>>>
>>> After that, migrate your data from the broken fs to the new one. If
>>> you use Btrfs for the new volume on that 2nd partition you can use
>>> btrfs send-receive for this. After it's successful, you can wipefs the
>>> 1st partition, and then add it as an additional device to the new
>>> volume.
>>>
>>> --
>>> Chris Murphy
