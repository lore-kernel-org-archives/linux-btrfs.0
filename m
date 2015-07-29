Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3974 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbbG2DVn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 23:21:43 -0400
Subject: Re: mkfs.btrfs with invalid -d option uses default single drive,
 rather than errors
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn63oURx2yKAJS4cCR+9v8fdx950RervzmXqTtXbHXn+gg@mail.gmail.com>
 <CAJCQCtSJxQ75UbYpNk-NC8j4z63RmToHRhODv9xbhM9muyqC0w@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B846C2.8040207@cn.fujitsu.com>
Date: Wed, 29 Jul 2015 11:21:38 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSJxQ75UbYpNk-NC8j4z63RmToHRhODv9xbhM9muyqC0w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/07/28 21:14 -0600:
> On Tue, Jul 28, 2015 at 8:16 PM, james harvey <jamespharvey20@gmail.com> wrote:
>> Doing some fast-paced benchmarking of lots of raid levels, some in a
>> kvm, some via RDMA access over InfiniBand using different procotols,
>> etc.
>>
>> Was shocked to see horrible raid0 performance in one of the tests.
>> Looked back through the logs and found:
>>
>> (Note that I typo'ed -d raid**e**0
>>
>> =====
>> $ sudo mkfs.btrfs -f -m raid0 -d raide0 /dev/vda2 /dev/vdb1 /dev/vdc1
>> Unknown profile raide0
>
> For raid0, at least going to single is a lower risk of data loss. But
> what if the user specified raid1 but instead single and hence higher
> risk of data loss? Probably better to fail the command than ignore -d
> switch and continue.
>
>
Yes, patch already sent.

It seems to be small typo, as the author expects the last return 0 won't 
be reached, but maybe just forgot the exit(1) at the error routine.

Thanks,
Qu
