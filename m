Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55677 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3EQBtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 21:49:46 -0400
Message-ID: <51958CFB.5040402@cn.fujitsu.com>
Date: Fri, 17 May 2013 09:50:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 06/17] Btrfs: introduce grab/put functions for the root
 of the fs/file tree
References: <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com> <20130516033645.GF20202@liubo.jp.oracle.com> <5194610F.1000603@cn.fujitsu.com> <20130516051556.GH20202@liubo.jp.oracle.com> <51946FD3.5000008@cn.fujitsu.com> <20130516061552.GI20202@liubo.jp.oracle.com> <5194893D.90505@cn.fujitsu.com> <20130516115417.24668.98321@localhost.localdomain> <20130516143138.GL20202@liubo.jp.oracle.com> <20130516143455.24668.84660@localhost.localdomain> <20130516145706.GM20202@liubo.jp.oracle.com>
In-Reply-To: <20130516145706.GM20202@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 16 May 2013 22:57:07 +0800, Liu Bo wrote:
> On Thu, May 16, 2013 at 10:34:55AM -0400, Chris Mason wrote:
>> Quoting Liu Bo (2013-05-16 10:31:39)
>>> On Thu, May 16, 2013 at 07:54:17AM -0400, Chris Mason wrote:
>>>> Quoting Miao Xie (2013-05-16 03:22:37)
>>>>>> I must say that the patch itself looks harmless, the reason is not good enough.
>>>>>
>>>>> I don't agree with you.
>>>>> It is perishing that The memory reclaim task is blocked for a long time. We should avoid
>>>>> this problem.
>>>>
>>>> synchronize_rcu and friends can take a very very long time.  I like this
>>>> patch as a way to avoid them, it's just keeps the whole kernel moving.
>>>>
>>>> -chris
>>>
>>> Okay, that teaches me another lesson, thanks Miao :)
>>
>> Actually using the rcu api isn't a huge impact.  It's just the
>> synchronize_rcu variants that should be avoided ;)
>>
>> -chris
>>
> 
> Now that it's so slow, I wonder why not use call_srcu() instead?

I have considered this approach, but there is a problem that someone may insert
a new inode after we call call_srcu(). So I had to make this patch as a interim
solution. My next work is to remove synchronize_srcu() from tree_del_inode().

Thanks
Miao
