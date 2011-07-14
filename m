From: Josef Bacik <josef@redhat.com>
Subject: Re: Delayed inode operations not doing the right thing with enospc
Date: Thu, 14 Jul 2011 13:57:49 -0400
Message-ID: <4E1F2E1D.80106@redhat.com>
References: <4DE92BF2.1060905@redhat.com>	<4DED8143.3090803@cn.fujitsu.com>	<4DEE9263.1000802@redhat.com>	<CAO47_--zux0kiKsY9Edinj98ihoXP4n2ton+j5LgdpNJv9hLbQ@mail.gmail.com>	<4E1DB22F.1060405@redhat.com> <CAO47_-9qn31AfGQksLnRAreMudBcOQz0UnXxmhFC4cSQW5ZHFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: chb@muc.de
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9qn31AfGQksLnRAreMudBcOQz0UnXxmhFC4cSQW5ZHFQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2011 03:27 AM, Christian Brunner wrote:
> 2011/7/13 Josef Bacik <josef@redhat.com>:
>> On 07/12/2011 11:20 AM, Christian Brunner wrote:
>>> 2011/6/7 Josef Bacik <josef@redhat.com>:
>>>> On 06/06/2011 09:39 PM, Miao Xie wrote:
>>>>> On fri, 03 Jun 2011 14:46:10 -0400, Josef Bacik wrote:
>>>>>> I got a lot of these when running stress.sh on my test box
>>>>>>
>>>>>>
>>>>>>
>>>>>> This is because use_block_rsv() is having to do a
>>>>>> reserve_metadata_bytes(), which shouldn't happen as we should have
>>>>>> reserved enough space for those operations to complete.  This is
>>>>>> happening because use_block_rsv() will call get_block_rsv(), which if
>>>>>> root->ref_cows is set (which is the case on all fs roots) we will use
>>>>>> trans->block_rsv, which will only have what the current transaction
>>>>>> starter had reserved.
>>>>>>
>>>>>> What needs to be done instead is we need to have a block reserve that
>>>>>> any reservation that is done at create time for these inodes is migrated
>>>>>> to this special reserve, and then when you run the delayed inode items
>>>>>> stuff you set trans->block_rsv to the special block reserve so the
>>>>>> accounting is all done properly.
>>>>>>
>>>>>> This is just off the top of my head, there may be a better way to do it,
>>>>>> I've not actually looked that the delayed inode code at all.
>>>>>>
>>>>>> I would do this myself but I have a ever increasing list of shit to do
>>>>>> so will somebody pick this up and fix it please?  Thanks,
>>>>>
>>>>> Sorry, it's my miss.
>>>>> I forgot to set trans->block_rsv to global_block_rsv, since we have migrated
>>>>> the space from trans_block_rsv to global_block_rsv.
>>>>>
>>>>> I'll fix it soon.
>>>>>
>>>>
>>>> There is another problem, we're failing xfstest 204.  I tried making
>>>> reserve_metadata_bytes commit the transaction regardless of whether or
>>>> not there were pinned bytes but the test just hung there.  Usually it
>>>> takes 7 seconds to run and I ctrl+c'ed it after a couple of minutes.
>>>> 204 just creates a crap ton of files, which is what is killing us.
>>>> There needs to be a way to start flushing delayed inode items so we can
>>>> reclaim the space they are holding onto so we don't get enospc, and it
>>>> needs to be better than just committing the transaction because that is
>>>> dog slow.  Thanks,
>>>>
>>>> Josef
>>>
>>> Is there a solution for this?
>>>
>>> I'm running a 2.6.38.8 kernel with all the btrfs patches from 3.0rc7
>>> (except the pluging). When starting a ceph rebuild on the btrfs
>>> volumes I get a lot of warnings from block_rsv_use_bytes in
>>> use_block_rsv:
>>>
>>
>> Ok I think I've got this nailed down.  Will you run with this patch and make sure the warnings go away?  Thanks,
> 
> I'm sorry, I'm still getting a lot of warnings like the one below.
> 
> I've also noticed, that I'm not getting these messages when the
> free_space_cache is disabled.
> 
>

Actually scratch that last note, it's wrong.  I'll send you an updated
patch when I've got this mess all sorted out.  Thanks,

Josef
