Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51196 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbaJGNUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 09:20:33 -0400
Date: Tue, 7 Oct 2014 09:19:52 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs send and kernel 3.17
To: David Arendt <admin@prnet.org>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412687992.2562.2@mail.thefacebook.com>
In-Reply-To: <DC336054-F307-4A86-AD6D-204E700DE9AA@prnet.org>
References: <DC336054-F307-4A86-AD6D-204E700DE9AA@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Oct 7, 2014 at 1:25 AM, David Arendt <admin@prnet.org> wrote:
> I did a revert of this commit. After creating a snapshot, the 
> filesystem was no longer usable, even with kernel 3.16.3 (crashes 10 
> seconds after mount without error message) . Maybe there was some 
> previous damage that just appeared now. This evening, I will restore 
> from backup and report back.
> 
> On October 7, 2014 12:22:11 AM CEST, Chris Mason <clm@fb.com> wrote:
>> On Mon, Oct 6, 2014 at 4:51 PM, David Arendt <admin@prnet.org> wrote:
>>>  I just tried downgrading to 3.16.3 again. In 3.16.3 btrfs send is
>>>  working without any problem. Afterwards I upgraded again to 3.17 
>>> and
>>>  the
>>>  problem reappeared. So the problem seems to be kernel version 
>>> related.
>> 
>> [ backref errors during btrfs-send ]
>> 
>> Ok then, our list of suspects is pretty short.  Can you easily build
>> test kernels?
>> 
>> I'd like to try reverting this commit:
>> 
>> 51f395ad4058883e4273b02fdebe98072dbdc0d2

Oh no!  Reverting this definitely should not have caused corruptions, 
so I think the problem was already there.  Do you still have the 
filesystem image?

Please let us know if you're missing files off the backup, we'll help 
pull them out.

-chris

