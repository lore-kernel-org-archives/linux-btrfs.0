Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:57744 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaLJOvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 09:51:32 -0500
Received: by mail-yh0-f53.google.com with SMTP id i57so1319596yha.26
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 06:51:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54882634.4000809@pobox.com>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<548743CE.1020403@inwind.it>
	<54879CFE.1090909@cn.fujitsu.com>
	<54882634.4000809@pobox.com>
Date: Wed, 10 Dec 2014 22:51:31 +0800
Message-ID: <CA+qeAOoERxpc72mDc-Sh0mhNpZMh4Zw+a3FdRvZ_e92gqZGcJw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, kreijack@inwind.it,
        lists@colorremedies.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 10, 2014 at 6:53 PM, Robert White <rwhite@pobox.com> wrote:
> On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
>>
>> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>>>
>>> Hi Dongsheng
>>> On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>>>
>>>> When function btrfs_statfs() calculate the tatol size of fs, it is
>>>> calculating
>>>> the total size of disks and then dividing it by a factor. But in some
>>>> usecase,
>>>> the result is not good to user.
>>>>
>>>> Example:
>>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>>     # mount /dev/vdf1 /mnt
>>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>>     # df -h /mnt
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>>
>>>>     # btrfs fi show /dev/vdf1
>>>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>>>>     Total devices 2 FS bytes used 1001.53MiB
>>>>     devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
>>>>     devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>>>>
>>>> a. df -h should report Size as 2GiB rather than as 3GiB.
>>>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>>>
>>> I agree
>
>
> NOPE.
>
> The model you propose is too simple.
>
> While the data portion of the file system is set to RAID1 the metadata
> portion of the filesystem is still set to the default of DUP. As such it is
> impossible to guess how much space is "free" since it is unknown how the
> space will be used before hand.
>
> IF, say, this were used as a typical mail spool, web cache, or any number of
> similar smal-file applications virtually all of the data may end up in the
> metadata chunks. The "blocks free" in this usage are indistinguisable from
> any other file system.
>
> For all that DUP data the correct size is 3GiB because there will be two
> copies of all metadata but they could _all_ end up on /dev/vdf2.
>
> So you have a RAID-1 region that is constrained to 2Gib. You have 2GiB more
> storage for all your metadata, but the constraint is DUP (so everything is
> written twice "somewhere")
>
> So the space breakdown is, if optimally packed, actually

The issue you pointed here really exists. If the all data is stored inline,
the raid level will probably be different with the raid level we set by "-d".

If we want to give an exactly guess of the future use, I would say
it's impossible.

But, 2G of the @size is more proper than 3G in this case I think.

Let's compare them as below:

2G:
    a). It's readable to user, we build a btrfs with two devices of 2G and 4G.
Then we got an fs of 2G. That's what raid1 should be understood.
    b). Even if all data is stored in inline extent, the @size will also grows
at the same time. That said, if as you said, we got 3G data in it. The @size
will also be reported as 3G in df command.

3G:
   a). It is strange to user, why we got a fs of 3G in raid1 with 2G
and 4G device?
And why I can not use the all the 3G capacity df reported (we can not assume a
user understand what's inline extent.)?

So, I prefer 2G to 3G here. Furthermore, I have cooked a new patch to treat
space in metadata chunk and system chunk more properly. shown as below.
        # df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdf1       2.0G  1.3G  713M  66% /mnt
        # df /mnt
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/vdf1        2097152 1359424    729536  66% /mnt
        # btrfs fi show /dev/vdf1
Label: none  uuid: e98c1321-645f-4457-b20d-4f41dc1cf2f4
        Total devices 2 FS bytes used 1001.55MiB
        devid    1 size 2.00GiB used 1.85GiB path /dev/vdf1
        devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2

Does this makes more sense to you, Robert?

Thanx
Yang

>
> 2GiB mirrored, for _data_, takes up 4GiB total spread evenly across
> /dev/vdf2 (2Gib) and /dev/vdf1 (2Gib).
>
> _AND_ 1GiB of metadata, written twice to /dev/vdf2 (2Gib)
>
> So free space is 3Gib on the presumption that data and metadata will be
> equally used.
>
> The program, not being psychic, can only make a fair-usage guess about
> future use.
>
> Now we have accounted for all 6GiB of raw storage _and_ the report of 3GiB
> free.
>
> IF you wanted everything to be RAID-1 you should have instead done
>
> # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1 -m raid1
>
> The mistake is yours, rest of you analysis is, therefore, completely
> inapplicable. Please read all the documentation before making that sort of
> filesystem. Your data will thank you later.
>
> DSCLAIMER: I have _not_ looked at the numbers you would get if you used the
> corrected command.
>
>
>
>>>
>>>> b. df -h should report Avail as 0.15GiB or less, rather than as 1.3GiB.
>>>> 2 - 1.85 = 0.15
>>>
>>> I cannot agree; the avail should be:
>>>      1.85           (the capacity of the allocated chunk)
>>>     -1.018          (the file stored)
>>>     +(2-1.85=0.15)  (the residual capacity of the disks
>>>                      considering a raid1 fs)
>>>     ---------------
>>> =   0.97
>>
>>
>> My bad here. It should be 0.97. My mistake in this changelog.
>> I will update it in next version.
>>>>
>>>> This patch drops the factor at all and calculate the size observable to
>>>> user without considering which raid level the data is in and what's the
>>>> size exactly in disk.
>>>>
>>>> After this patch applied:
>>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>>     # mount /dev/vdf1 /mnt
>>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>>     # df -h /mnt
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/vdf1       2.0G 1018M  713M  59% /mnt
>>>
>>> I am confused: in this example you reported as Avail 713MB, when previous
>>> you stated that the right value should be 150MB...
>>
>>
>> As you pointed above, the right value should be 970MB or less (Some
>> space is used for metadata and system).
>> And the 713MB is my result of it.
>>>
>>>
>>> What happens when the filesystem is RAID5/RAID6 or Linear ?
>>
>>
>> The original df did not consider the RAID5/6. So it still does not work
>> well with
>> this patch applied. But I will update this patch to handle these
>> scenarios in V2.
>>
>> Thanx
>> Yang
>>
>>   [...]
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
