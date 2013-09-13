Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3IMCNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 22:13:43 -0400
Message-ID: <52327289.9020404@cn.fujitsu.com>
Date: Fri, 13 Sep 2013 10:03:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: Replace the btrfs_workers with kernel workqueue
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com> <20130912173718.GE6810@twin.jikos.cz>
In-Reply-To: <20130912173718.GE6810@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

于 2013年09月13日 01:37, David Sterba 写道:
> On Thu, Sep 12, 2013 at 04:08:15PM +0800, Qu Wenruo wrote:
>> Use kernel workqueue and kernel workqueue based new btrfs_workqueue_struct to replace
>> the old btrfs_workers.
>> The main goal is to reduce the redundant codes(800 lines vs 200 lines) and
>> try to get benefits from the latest workqueue changes.
>>
>> About the performance, the test suite I used is bonnie++,
>> and there seems no significant regression.
> You're replacing a core infrastructure building block, more testing is
> absolutely required, but using the available infrastructure is a good
> move.
Definitely needs more test since the I lack enough different disks to 
test with.
>
> I found a few things that do not replace the current implementation
> one-to-one:
>
> * the thread names lost the btrfs- prefix, this makes it hard to
>    identify the processes and we want this, either debugging or
>    performance monitoring
Yes, that's right.
But the problem is, even I added "btrfs-" prefix to the wq,
the real work executor is kernel workers without any prefix.
Still hard to debugging due to the workqueue mechanism.
>
> * od high priority tasks were handled in threads with unchanged priority
>    and just prioritized within the queue
>    newly addded WQ_HIGHPRI elevates the nice level of the thread, ie.
>    it's not the same thing as before -- I need to look closer
Also true, since I didn't find a way to ensure the high priority work
to be executed before any normal priority work,
I choose this workaround.
(Seems the original btrfs_workers also have some mechanism to avoid
starving, so I think this way maybe OK)
>
> * the idle_thresh attribute is not reflected in the new code, I don't
>    know if the kernel workqueues have something equivalent
It seems that kernel will not create kthread without any control,
but still needs more investigation to make sure.
>
>
> Other random comments:
>
> * you can use the same files for the new helpers, instead of bwq.[ch]
The way I used is to avoid naming confliction and easy to clean.
If needed I'll also use the async-thread.[ch]
>
> * btrfs_workqueue_struct can drop the _struct suffix
The naming rule is mostly copied from kernel wq and just add "btrfs_" prefix
if no naming confliction.
Will modify if needed.
> * WQ_MEM_RECLAIM for the scrub thread does not seem right
>
> * WQ_FREEZABLE should be probably set
Will modify soon.

>
>
> david
>

Thanks for the comment.

Qu

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

