Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41011 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715AbaI2DUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 23:20:06 -0400
Message-ID: <5428CFE6.3060703@cn.fujitsu.com>
Date: Mon, 29 Sep 2014 11:20:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC: "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: [bug] btrfs check --subvol-extents segfault
References: <BB091951-5382-4788-901D-20E96546548A@colorremedies.com> <5418AD03.4090301@redhat.com>
In-Reply-To: <5418AD03.4090301@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping.

No response?

Thanks,
Qu
-------- Original Message --------
Subject: Re: [bug] btrfs check --subvol-extents segfault
From: Eric Sandeen <sandeen@redhat.com>
To: Chris Murphy <lists@colorremedies.com>, Btrfs BTRFS 
<linux-btrfs@vger.kernel.org>
Date: 2014年09月17日 05:34
> On 9/16/14 4:33 PM, Chris Murphy wrote:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1142421
>>
>> kernel-3.17.0-0.rc5.git0.1.fc22.x86_64
>> btrfs-progs-3.16-1.fc21.x86_64
>>
>> Steps to Reproduce:
>> 1. mkfs.btrfs /dev/sdc
>> 2. btrfs check --subvol-extents /dev/sdc
>>
>> Results:
>> Segmentation fault (core dumped)
>>
>> [  632.749774] btrfs[692]: segfault at 0 ip 00007fc9963fdd77 sp 00007fff93450880 error 4 in libc-2.19.90.so[7fc9963c2000+1bd000]
>>
>> Eric Sandeed writes in the bugzilla that this was broken by commit
>> d34cbe76c723a05a14bbcfdc46e8ede789c3f1f9 which drops the requirement
>> to specify a subvolid, but still does arg_strtou64(optarg) ->
>> arg_strtou64(NULL) so it crashes.
> Yeah, AFAICT (although it's not documented anywhere) the functionality is
> *supposed* to take a subvolid as an argument.
>
> The commit lets it pass w/ no args, but still does arg_strtou64(optarg) to get
> the subvolid, and boom.
>
> I think the commit just needs to be reverted, and then manpages updated &
> testcases written...
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

