Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44965 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab3KHAwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:52:15 -0500
Message-ID: <527C35EC.8000307@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 08:53:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] btrfs: Add high priority workqueue support for
 btrfs_workqueue_struct
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com> <20131107164134.GJ16662@twin.jikos.cz>
In-Reply-To: <20131107164134.GJ16662@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Nov 2013 17:41:34 +0100, David Sterba wrote:
> On Thu, Nov 07, 2013 at 01:51:53PM +0800, Qu Wenruo wrote:
>> @@ -753,6 +754,19 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>   		}
>>   	}
>>   
>> +	if (high_name) {
>> +		ret->high_wq = alloc_workqueue(high_name,
>> +					       flags | WQ_HIGHPRI,
>> +					       max_active);
> I'd really like to add the btrfs- prefix of the workqueue. Quoting our
> previous discussion:
Sorry, I forgot to add the "btrfs-" prefix.
But on the other hand, I prefer to add the prefix outside the 
alloc_btrfs_workqueue,
which means change the strings passed to alloc_btrfs_workqueue.
(Maybe add a small macro?)

Which way do you prefer?
>
>>> * the thread names lost the btrfs- prefix, this makes it hard to
>>>     identify the processes and we want this, either debugging or
>>>     performance monitoring
>> Yes, that's right.
>> But the problem is, even I added "btrfs-" prefix to the wq,
>> the real work executor is kernel workers without any prefix.
>> Still hard to debugging due to the workqueue mechanism.
> AFAICS the string passed down to alloc_workqueue ends up in the process
> name, this is what I'm expecing and don't understand what do you mean.
>
>
> david
>
Sorry for the misunderstanding words.
What I mean is that, since we use the kernel workqueue,
there will be no kthread named the "btrfs-worker" or something like it.
(Only when WQ_MEM_RECLAIM is set, the rescuer kthread will have the name,
See kernel/workqueue.c if(flags & WQ_MEM_RECLAIM) para).

The real executor will be something like kworker/u8:6(Unbound workqueue),
so even the prefix is added, it's still harder than the original way to 
debug
workqueue.

What makes it worse is that, to simulate the thresholding and ordering,
I added serveral helper functions, which even makes kernel tracing not so
meaningful(all function queued to workqueue will all be normal_helper or
ordered_helper).

Neither way, the prefix will be added, but I consider this may not really
help to debug or monitor.

Qu.



-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
