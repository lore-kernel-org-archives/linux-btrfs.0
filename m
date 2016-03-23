Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36623 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbcCWT1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 15:27:09 -0400
Received: by mail-lf0-f50.google.com with SMTP id d82so18921506lfe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 12:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F2EA25.4070004@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
Date: Wed, 23 Mar 2016 20:27:07 +0100
Message-ID: <CAGGqMYTOuSijf3wh1sS9Eac6Px=XMm-mSwVV0NWQkfYXdwSiQA@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Alexander Fougner <fougner89@gmail.com>
To: bradtem@gmail.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-23 20:10 GMT+01:00 Brad Templeton <bradtem@gmail.com>:
> It is Ubuntu wily, which is 4.2 and btrfs-progs 0.4.  I will upgrade to
> Xenial in April but probably not before, I don't have days to spend on
> this.   Is there a fairly safe ppa to pull 4.4 or 4.5?

Use the mainline ppa: http://kernel.ubuntu.com/~kernel-ppa/mainline/
Instructions: https://wiki.ubuntu.com/Kernel/MainlineBuilds

You can also find a newer btrfs-progs .deb here:
launchpad.net/ubuntu/+source/btrfs-tools

 In olden days, I
> would patch and build my kernels from source but I just don't have time
> for all the long-term sysadmin burden that creates any more.
>
> Also, I presume if this is a bug, it's in btrfsprogs, though the new one
> presumably needs a newer kernel too.
>
> I am surprised to hear it said that having the mixed sizes is an odd
> case.  That was actually one of the more compelling features of btrfs
> that made me switch from mdadm, lvm and the rest.   I presumed most
> people were the same. You need more space, you go out and buy a new
> drive and of course the new drive is bigger than the old drives you
> bought because they always get bigger.  Under mdadm the bigger drive
> still helped, because it replaced at smaller drive, the one that was
> holding the RAID back, but you didn't get to use all the big drive until
> a year later when you had upgraded them all.  In the meantime you used
> the extra space in other RAIDs.  (For example, a raid-5 plus a raid-1 on
> the 2 bigger drives) Or you used the extra space as non-RAID space, ie.
> space for static stuff that has offline backups.  In fact, most of my
> storage is of that class (photo archives, reciprocal backups of other
> systems) where RAID is not needed.
>
> So the long story is, I think most home users are likely to always have
> different sizes and want their FS to treat it well.
>
> Since 6TB is a relatively new size, I wonder if that plays a role.  More
> than 4TB of free space to balance into, could that confuse it?
>
> Off to do a backup (good idea anyway.)
>
>
>
> On 03/23/2016 11:34 AM, Chris Murphy wrote:
>> On Wed, Mar 23, 2016 at 10:51 AM, Brad Templeton <bradtem@gmail.com> wrote:
>>> Thanks for assist.  To reiterate what I said in private:
>>>
>>> a) I am fairly sure I swapped drives by adding the 6TB drive and then
>>> removing the 2TB drive, which would not have made the 6TB think it was
>>> only 2TB.    The btrfs statistics commands have shown from the beginning
>>> the size of the device as 6TB, and that after the remove, it haad 4TB
>>> unallocated.
>>
>> I agree this seems to be consistent with what's been reported.
>>
>>
>>>
>>> So I am looking for other options, or if people have commands I might
>>> execute to diagnose this (as it seems to be a flaw in balance) let me know.
>>
>> What version of btrfs-progs is this? I'm vaguely curious what 'btrfs
>> check' reports (without --repair). Any version is OK but it's better
>> to use something fairly recent since the check code continues to
>> change a lot.
>>
>> Another thing you could try is a newer kernel. Maybe there's a related
>> bug in 4.2.0. I think it may be more likely this is just an edge case
>> bug that's always been there, but it's valuable to know if recent
>> kernels exhibit the problem.
>>
>> And before proceeding with a change in layout (converting to another
>> profile) I suggest taking an image of the metadata with btrfs-image,
>> it might come in handy for a developer.
>>
>>
>>
>>>
>>> Some options remaining open to me:
>>>
>>> a) I could re-add the 2TB device, which is still there.  Then balance
>>> again, which hopefully would move a lot of stuff.   Then remove it again
>>> and hopefully the new stuff would distribute mostly to the large drive.
>>>  Then I could try balance again.
>>
>> Yeah, to do this will require -f to wipe the signature info from that
>> drive when you add it. But I don't think this is a case of needing
>> more free space, I think it might be due to the odd number of drives
>> that are also fairly different in size.
>>
>> But then what happens when you delete the 2TB drive after the balance?
>> Do you end up right back in this same situation?
>>
>>
>>
>>>
>>> b) It was suggested I could (with a good backup) convert the drive to
>>> non-RAID1 to free up tons of space and then re-convert.  What's the
>>> precise procedure for that?  Perhaps I can do it with a limit to see how
>>> it works as an experiment?   Any way to specifically target the blocks
>>> that have their two copies on the 2 smaller drives for conversion?
>>
>> btrfs balance -dconvert=single -mconvert=single -f   ## you have to
>> use -f to force reduction in redundancy
>> btrfs balance -dconvert=raid1 -mconvert=raid1
>>
>> There is the devid= filter but I'm not sure of the consequences of
>> limiting the conversion to two of three devices, that's kinda
>> confusing and is sufficiently an edge case I wonder how many bugs
>> you're looking to find today? :-)
>>
>>
>>
>>> c) Finally, I could take a full-full backup (my normal backups don't
>>> bother with cached stuff and certain other things that you can recover)
>>> and take the system down for a while to just wipe and restore the
>>> volumes.  That doesn't find the bug, however.
>>
>> I'd have the full backup no matter what choice you make. At any time
>> for any reason any filesystem can face plant without warning.
>>
>> But yes this should definitely work or else you've definitely found a
>> bug. Finding the bug in your current scenario is harder because the
>> history of this volume makes it really non-deterministic whereas if
>> you start with a 3 disk volume at mkfs time, and then you reproduce
>> this problem, for sure it's a bug. And fairly straightforward to
>> reproduce.
>>
>> I still recommend a newer kernel and progs though, just because
>> there's no work being done on 4.2 anymore. I suggest 4.4.6 and 4.4.1
>> progs. And then if you reproduce it, it's not just a bug, it's a
>> current bug.
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
