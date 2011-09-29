From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix missing clear_extent_bit
Date: Thu, 29 Sep 2011 08:51:36 +0800
Message-ID: <4E83C118.2050805@cn.fujitsu.com>
References: <1317204034-11239-1-git-send-email-liubo2009@cn.fujitsu.com> <4E83143B.3050907@redhat.com> <1317216807-sup-5328@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317216807-sup-5328@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2011 09:44 PM, Chris Mason wrote:
> Excerpts from Josef Bacik's message of 2011-09-28 08:34:03 -0400:
>> On 09/28/2011 06:00 AM, Liu Bo wrote:
>>> We forget to clear inode's dirty_bytes and EXTENT_DIRTY at the end of write.
>>>
>> We don't set EXTENT_DIRTY unless we failed to read a block and that's to
>> keep track of the area we are re-reading, unless I'm missing something?
>>  Thanks,
> 
> Josef and I have been talking about this one on IRC.
> We do set EXTENT_DIRTY during set_extent_delalloc, but as far as I can
> tell we no longer need to.  Can you please experiment with just not
> setting the dirty bit during delalloc instead?
> 

Sure.  So this EXTENT_DIRTY is only for METADATA use.

thanks,
liubo

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

