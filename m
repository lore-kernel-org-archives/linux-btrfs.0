Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:53010 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732263AbeGKBDz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 21:03:55 -0400
Subject: Re: btrfs check lowmem, take 2
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>,
        Su Yue <Damenly_Su@gmx.com>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
 <20180711005852.prhnmohkzjplw54j@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <9b612c36-f59c-b4c7-bb84-4a30c4a7d453@cn.fujitsu.com>
Date: Wed, 11 Jul 2018 09:08:40 +0800
MIME-Version: 1.0
In-Reply-To: <20180711005852.prhnmohkzjplw54j@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2018 08:58 AM, Marc MERLIN wrote:
> On Wed, Jul 11, 2018 at 08:53:58AM +0800, Su Yue wrote:
>>> Problems
>>> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
>>> server, despite my deleting lots of snapshots.
>>> Is it because I have too many files then?
>>>
>> Yes. Original check first gather all infomation about extent tree and
>> your files in RAM, then process one by one.
>> But deleting still counts, it does speed lowmem check up.
> 
> Understood.
> 
>>> 2) I tried Su's master git branch for btrfs-progs to try and see how
>> Oh..No... My master branch is still 4.14. The true mater branch is
>> David's here:
>> https://github.com/kdave/btrfs-progs
>> But the master branch has a known bug which I fixed yesterday, please see
>> the mail.
> 
> So, if I git sync it now, it should have your fix, and I can run it,
> correct?
> 
Yes, please.

Thanks,
Su
> Thanks,
> Marc
> 


