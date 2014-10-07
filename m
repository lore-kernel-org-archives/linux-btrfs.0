Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44858 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaJGUpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 16:45:23 -0400
Message-ID: <543450DC.90504@prnet.org>
Date: Tue, 07 Oct 2014 22:45:16 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send and kernel 3.17
References: <DC336054-F307-4A86-AD6D-204E700DE9AA@prnet.org> <1412687992.2562.2@mail.thefacebook.com>
In-Reply-To: <1412687992.2562.2@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/07/2014 03:19 PM, Chris Mason wrote:
>
>
> On Tue, Oct 7, 2014 at 1:25 AM, David Arendt <admin@prnet.org> wrote:
>> I did a revert of this commit. After creating a snapshot, the
>> filesystem was no longer usable, even with kernel 3.16.3 (crashes 10
>> seconds after mount without error message) . Maybe there was some
>> previous damage that just appeared now. This evening, I will restore
>> from backup and report back.
>>
>> On October 7, 2014 12:22:11 AM CEST, Chris Mason <clm@fb.com> wrote:
>>> On Mon, Oct 6, 2014 at 4:51 PM, David Arendt <admin@prnet.org> wrote:
>>>>  I just tried downgrading to 3.16.3 again. In 3.16.3 btrfs send is
>>>>  working without any problem. Afterwards I upgraded again to 3.17 and
>>>>  the
>>>>  problem reappeared. So the problem seems to be kernel version
>>>> related.
>>>
>>> [ backref errors during btrfs-send ]
>>>
>>> Ok then, our list of suspects is pretty short.  Can you easily build
>>> test kernels?
>>>
>>> I'd like to try reverting this commit:
>>>
>>> 51f395ad4058883e4273b02fdebe98072dbdc0d2
>
> Oh no!  Reverting this definitely should not have caused corruptions,
> so I think the problem was already there.  Do you still have the
> filesystem image?
>
> Please let us know if you're missing files off the backup, we'll help
> pull them out.
>
> -chris
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Due to space constraints, it was not possible to take an image of the
corrupted filesystem. As I do backups daily, and the problems occurred 5
hours after backup, no file was lost. Thanks for offering your help. In
4 days I will do some send tests on the newly created filesystem and
report back.
