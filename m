From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] direct-io: add a hook for the fs to provide its own
 bio merging check function
Date: Thu, 18 Nov 2010 09:18:18 +0800
Message-ID: <4CE47EDA.90205@cn.fujitsu.com>
References: <4CE3579B.1000301@cn.fujitsu.com> <20101117070658.GF5618@dhcp231-156.rdu.redhat.com> <20101117093720.GG5618@dhcp231-156.rdu.redhat.com> <4CE3AA37.8060709@cn.fujitsu.com> <20101117125011.GH5618@dhcp231-156.rdu.redhat.com> <1290012777-sup-9103@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Josef Bacik <josef@redhat.com>, viro <viro@zeniv.linux.org.uk>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1290012777-sup-9103@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 	wed, 17 Nov 2010 11:55:28 -0500, Chris Mason wrote:
> Excerpts from Josef Bacik's message of 2010-11-17 07:50:11 -0500:
>> On Wed, Nov 17, 2010 at 06:11:03PM +0800, Miao Xie wrote:
>>> Hi, Josef
>>>
>>> On wed, 17 Nov 2010 04:37:21 -0500, Josef Bacik wrote:
>>>>> Heh so I was going to fix this after the hole punching stuff.  The fact is btrfs
>>>>> maps everything that is ok to do in one IO via get_blocks().  So all we need to
>>>>> do is add another DIO_ flag to tell us to treat each get_blocks() call as
>>>>> discrete.  I wanted to use buffer_boundary for this, but I think it's too
>>>>> drastic of a change for people who already use buffer_boundary();
>>>>>
>>>>> What happens today is that say we map 4k, we do submit_page_section, but if this
>>>>> is our first bit of IO we just set dio->cur_page and such and then loop again.
>>>>> Say there is 4k-hole-4k, we do the next mapping and set buffer_boundary again,
>>>>> and come into submit_page_section and because cur_page is set, we do
>>>>> dio_send_cur_page.  Because there is no dio->bio we setup a new bio, but when we
>>>>> do that we clear dio->boundary, and leave the bio all setup.  So the next time
>>>>> we loop around the tail 4k gets added to our previously setup bio and boom we
>>>>> hit this problem with btrfs.
>>>>>
>>>>> If we can add a DIO_GET_BLOCKS_DISCRETE or some other such non-sense then we can
>>>>> easily kill all the logical offset code I had and just make some simple changes
>>>>> to make the DIO stuff work for us.  All we do is in get_more_blocks we do
>>>>>
>>>>> if ((dio->flags&   DIO_GET_BLOCKS_DISCRETE)&&   dio->bio)
>>>>>      dio_submit_bio(dio);
>>>>>
>>>>
>>>> Right after I went to bed I realized this should be
>>>>
>>>> if (dio->flags&   DIO_GET_BLOCKS_DISCRETE) {
>>>>      if (dio->cur_page) {
>>>>          dio_send_cur_page(dio);
>>>>          page_cache_release(dio->cur_page);
>>>>          dio->cur_page = NULL;
>>>>      }
>>>>
>>>>      if (dio->bio)
>>>>          dio_submit_bio(dio);
>>>>    }
>>>
>>> As far as I know, get_block() can not make sure the IO doesn't span the chunks or
>>> stripes. Maybe we can do this check in get_blocks(). In this way, we needn't change
>>> vfs.
>>>
>>
>> Right thats the idea, if we can't span chunks/stripes we should be doing that
>> limiting in our get_blocks call and that way we don't have to screw with the
>> generic direct io stuff too much.  Thanks,
>
> In this case we're adding complexity to the O_DIRECT mapping code, when
> we really should be adding it to the btrfs submit bio hook.  It can
> easily break up the bio into smaller units, which will leave us with a
> smaller number of get_blocks calls overall.
>
> I'm working that out now.

Do you mean you are fixing this bug now?

Thanks
Miao
