Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbbCQCld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 22:41:33 -0400
Message-ID: <55079458.1010209@cn.fujitsu.com>
Date: Tue, 17 Mar 2015 10:41:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        <linux-btrfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com> <550127E1.4050606@cn.fujitsu.com> <20150312173414.GE20767@twin.jikos.cz> <20150312201508.GB10724@localhost.localdomain> <20150316162534.GO20767@twin.jikos.cz>
In-Reply-To: <20150316162534.GO20767@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older 
mkfs"
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Date: 2015年03月17日 00:25

> On Fri, Mar 13, 2015 at 04:15:08AM +0800, Liu Bo wrote:
>> On Thu, Mar 12, 2015 at 06:34:15PM +0100, David Sterba wrote:
>>> On Thu, Mar 12, 2015 at 01:45:05PM +0800, Qu Wenruo wrote:
>>>> I sent such patch some time ago but was rejected by Chris,
>>>> hopes this time it can be accepted.
>>>
>>> http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34937.html
>>>
>>> I'm OK with removing the special case now because there are additional
>>> supreblock checks merged (3.19) that were motivated by your previous
>>> attempt to remove it.
>>
>> So David, are you going to take the above patch instead?
>>
>> I'm okay with that since they're exactly same, but it'd be good that
>> Qu has its commit log updated.
>
> Although Qu's patch was first and should be normally applied in case
> more patches doing the same thing, the changelog reasoning is IMHO not
> all fine, so I'm inclined to take your patch if you refine the subject,
> and drop the "Conflicts:". Thanks.
>
I'm completely OK with picking Liu's patch, since his patch is submitted 
at a much more appropriate time than mine.
My patch is somewhat too early.

Thanks,
Qu
