Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39826 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbcDYAqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 20:46:35 -0400
Subject: Re: About fi du and reflink/dedupe
To: Mark Fasheh <mfasheh@suse.de>
References: <0e9b715e-0cb3-c7a3-e40e-36c9be1f53bd@cn.fujitsu.com>
 <20160422174613.GY2187@wotan.suse.de>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <af467dba-a1db-bd10-55f2-bbce5e434bc7@cn.fujitsu.com>
Date: Mon, 25 Apr 2016 08:46:24 +0800
MIME-Version: 1.0
In-Reply-To: <20160422174613.GY2187@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mark Fasheh wrote on 2016/04/22 10:46 -0700:
> On Fri, Apr 22, 2016 at 10:57:29AM +0800, Qu Wenruo wrote:
>> Hi Mark,
>>
>> Thanks for your contribution to btrfs-filesystem-du command.
>>
>> However there seems to be some strange behavior related to
>> reflinke(and further in-band dedupe).
>> (And the root cause is lying quite deep into kernel backref resolving codes)
>>
>> ["Exclusive" value not really exclsuive]
>> When a file with 2 file extents, and the 2nd file extent points to
>> the 1st one, the fi du gives wrong answer
>>
>> The following command can create such file easily.
>>
>> # mkfs.btrfs -f /dev/sdb5
>> # mount /dev/sdb5 /mnt/test
>> # xfs_io -f -c "pwrite 0 128K" /mnt/test/tmp
>> # xfs_io -c "reflink /mnt/test/tmp 0 128K 128K" /mnt/test/tmp
>> # btrfs fi du /mnt/test
>>      Total   Exclusive  Set shared  Filename
>>  256.00KiB   256.00KiB           -  /mnt/test//tmp
>>  256.00KiB   256.00KiB       0.00B  /mnt/test/
>>
>> Total seems to be OK, while I am confused of the exclusive value.
>>
>> As the above method will only create one real data extent, which
>> takes 128K, and if following the qgroup definition, its exclusive
>> should be 128K other than 256K.
>
> Ok that's a bug in how we're counting these. We already record extent start
> offsets so it's easy enough to see when we have the same extent in a file
> while we fiemap it. Thanks for reporting this I'll take a look at a fix.

The root cause is how we implement btrfs_check_shared().

It's using the most time consuming one, by walk through all backref 
until hit one backref whose inode/root is not the same with given one.

This works fine for small and non-deduped(no matter inband or 
out-of-band) files.

But when things go large, for example 8192 file extents, and no other 
inode/root is referring it, the backref walk takes long long time.

>
>
>> And what's more, if we modify btrfs_check_shared() to return SHARED
>> flag for such case, we will get 0 exclusive value for it.
>> Which is quite strang. (I assume the exclusive should be 128K)
>>
>> [Slow btrfs_check_shared() performance]
>> In above case, btrfs fi du returns very fast.
>> But when the file is in-band deduped and size goes to 1G.
>> btrfs_check_shared() will take a lot of time to return, as it will
>> do backref walk through.
>>
>> This would be a super huge problem for inband dedupe.
>>
>>
>> [Possible solution]
>> Would you please consider to judge shared extent in user space?
>> And don't rely on the SHARED flag from fiemap.
>
> _Absoletely Not_
>
> We don't ask userspace to modify their applications if there's a peformance
> problem in fiemap, we fix the performance problem in fiemap. Off the top of
> my head I can think of at least TWO other applications which rely on fiemap
> heavily. You will have very little luck in asking them to modify their
> applications.
>
> If btrfs fiemap is broken, we fix that full stop.

OK we will try to fix it by using faster lookup method and check backref 
offset.

But still, I am a little concerned on the fi du behavior on the 
exclusive values.

For example, if we fixed the fiemap performance bug and returning 
correct SHARED flag. For the following file layout: (a perfectly deduped 
one)
Offset: 0, len: 128K, disk bytenr: X, disk num bytes: 128K
Offset: 128K, len: 128K, disk bytenr: X, disk num bytes: 128K
Offset: 256K, len: 128K, disk bytenr: X, disk num bytes: 128K

And the disk bytenr X is only refered by this file.

What's the correct exclusive value for the file?
For current implement it would be 0 as all file extents have SHARED 
flag, but I thought it would be 128K, as the X is only referred by this 
file.

Any idea on this?

>
> More specifically, If in-band dedupe is causing fiemap to go out to lunch
> 'for a year', we need to address the core problem in in-band dedupe. If it's
> a general problem in btrfs fiemap when we need to track it down before users
> start yelling at us.
> 	--Mark

That's a fiemap problem, and dedupe (inband or out-of-band both) just 
makes it more easy to trigger.
(From this respect of view, inband dedupe is quite good at spotting 
corner case bugs)

Even without dedupe, user can still trigger it by reflinking.

As the old backref codes doesn't expect we will have so many reference 
on a single small extent.

This also reminds me that, we need to further enhance backref iteration 
codes, to make it better handle such case.

Thanks,
Qu

>
> --
> Mark Fasheh
>
>


