Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43974 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbcCWBNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 21:13:09 -0400
Subject: Re: Btrfsck memory usage reduce idea
To: <dsterba@suse.cz>, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <56DD14B6.4070908@cn.fujitsu.com>
 <56DE8D1D.5050504@jp.fujitsu.com> <56DE9171.8040309@cn.fujitsu.com>
 <20160318181854.GF21722@twin.jikos.cz> <56EF595B.7080509@cn.fujitsu.com>
 <20160322144927.GB29764@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F1ED93.2090402@cn.fujitsu.com>
Date: Wed, 23 Mar 2016 09:12:51 +0800
MIME-Version: 1.0
In-Reply-To: <20160322144927.GB29764@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/03/22 15:49 +0100:
> On Mon, Mar 21, 2016 at 10:15:55AM +0800, Qu Wenruo wrote:
>>> IOW, there will be two options for the use to choose from, right? That's
>>> what I'd expect. Be able to check the filesystem on a machine with less
>>> memory at the cost of IO, but also do the faster check on a different
>>> machine.
>>
>> I was planning to use the new extent tree check to replace current one,
>> as a rework.
>> Am I always reworking things? :)
>
> The problem with big reworks is that there are few people willing to
> review them. So I'm not against doing such changes, especially in this
> case it would be welcome, but I'm afraid that it could end up stalled
> similar to the convert rewrite.

So for convert rework, unless some other developer reviews the patchset, 
it won't be merged, right?


To avoid the same problem, what about submitting small patchsets and 
replace extent tree fsck codes part by part?
(Although not sure if it's possible)

Reviewers would be much more happy reviewing 5 patches for 5 times, 
other than reviewing a big 25 patchset.

Thanks,
Qu

>
>> The point that I didn't want to keep the current behavior is, the old
>> one is just OK or OOM, no one would know if it will OOM until it happens.
>>
>> But the new one would be much flex than current behavior.
>> As it fully uses the IO cache provided by kernel.
>
> That's a good point, for the single implementation.
>
>


