Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:32786 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaLJKxn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 05:53:43 -0500
Message-ID: <54882634.4000809@pobox.com>
Date: Wed, 10 Dec 2014 02:53:40 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, kreijack@inwind.it
CC: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com> <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com> <548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com>
In-Reply-To: <54879CFE.1090909@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>> Hi Dongsheng
>> On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>> When function btrfs_statfs() calculate the tatol size of fs, it is
>>> calculating
>>> the total size of disks and then dividing it by a factor. But in some
>>> usecase,
>>> the result is not good to user.
>>>
>>> Example:
>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>     # mount /dev/vdf1 /mnt
>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>     # df -h /mnt
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>
>>>     # btrfs fi show /dev/vdf1
>>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>>>     Total devices 2 FS bytes used 1001.53MiB
>>>     devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
>>>     devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>>>
>>> a. df -h should report Size as 2GiB rather than as 3GiB.
>>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>> I agree

NOPE.

The model you propose is too simple.

While the data portion of the file system is set to RAID1 the metadata 
portion of the filesystem is still set to the default of DUP. As such it 
is impossible to guess how much space is "free" since it is unknown how 
the space will be used before hand.

IF, say, this were used as a typical mail spool, web cache, or any 
number of similar smal-file applications virtually all of the data may 
end up in the metadata chunks. The "blocks free" in this usage are 
indistinguisable from any other file system.

For all that DUP data the correct size is 3GiB because there will be two 
copies of all metadata but they could _all_ end up on /dev/vdf2.

So you have a RAID-1 region that is constrained to 2Gib. You have 2GiB 
more storage for all your metadata, but the constraint is DUP (so 
everything is written twice "somewhere")

So the space breakdown is, if optimally packed, actually

2GiB mirrored, for _data_, takes up 4GiB total spread evenly across 
/dev/vdf2 (2Gib) and /dev/vdf1 (2Gib).

_AND_ 1GiB of metadata, written twice to /dev/vdf2 (2Gib)

So free space is 3Gib on the presumption that data and metadata will be 
equally used.

The program, not being psychic, can only make a fair-usage guess about 
future use.

Now we have accounted for all 6GiB of raw storage _and_ the report of 
3GiB free.

IF you wanted everything to be RAID-1 you should have instead done

# mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1 -m raid1

The mistake is yours, rest of you analysis is, therefore, completely 
inapplicable. Please read all the documentation before making that sort 
of filesystem. Your data will thank you later.

DSCLAIMER: I have _not_ looked at the numbers you would get if you used 
the corrected command.


>>
>>> b. df -h should report Avail as 0.15GiB or less, rather than as 1.3GiB.
>>> 2 - 1.85 = 0.15
>> I cannot agree; the avail should be:
>>      1.85           (the capacity of the allocated chunk)
>>     -1.018          (the file stored)
>>     +(2-1.85=0.15)  (the residual capacity of the disks
>>                      considering a raid1 fs)
>>     ---------------
>> =   0.97
>
> My bad here. It should be 0.97. My mistake in this changelog.
> I will update it in next version.
>>> This patch drops the factor at all and calculate the size observable to
>>> user without considering which raid level the data is in and what's the
>>> size exactly in disk.
>>>
>>> After this patch applied:
>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>     # mount /dev/vdf1 /mnt
>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>     # df -h /mnt
>>> Filesystem      Size  Used Avail Use% Mounted on
>>> /dev/vdf1       2.0G 1018M  713M  59% /mnt
>> I am confused: in this example you reported as Avail 713MB, when previous
>> you stated that the right value should be 150MB...
>
> As you pointed above, the right value should be 970MB or less (Some
> space is used for metadata and system).
> And the 713MB is my result of it.
>>
>> What happens when the filesystem is RAID5/RAID6 or Linear ?
>
> The original df did not consider the RAID5/6. So it still does not work
> well with
> this patch applied. But I will update this patch to handle these
> scenarios in V2.
>
> Thanx
> Yang
>
>   [...]
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

