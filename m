Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3ITGM1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 02:12:27 -0400
Message-ID: <523BE774.4070808@cn.fujitsu.com>
Date: Fri, 20 Sep 2013 14:13:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: Replace the btrfs_workers with kernel workqueue
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com> <20130912173718.GE6810@twin.jikos.cz>
In-Reply-To: <20130912173718.GE6810@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 12 Sep 2013 19:37:18 +0200, David Sterba wrote:
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
>
> I found a few things that do not replace the current implementation
> one-to-one:
>
> * the thread names lost the btrfs- prefix, this makes it hard to
>    identify the processes and we want this, either debugging or
>    performance monitoring
>
> * od high priority tasks were handled in threads with unchanged priority
>    and just prioritized within the queue
>    newly addded WQ_HIGHPRI elevates the nice level of the thread, ie.
>    it's not the same thing as before -- I need to look closer
>
> * the idle_thresh attribute is not reflected in the new code, I don't
>    know if the kernel workqueues have something equivalent
>
>
> Other random comments:
>
> * you can use the same files for the new helpers, instead of bwq.[ch]
>
> * btrfs_workqueue_struct can drop the _struct suffix
>
> * WQ_MEM_RECLAIM for the scrub thread does not seem right
I think scrub_workers,scrub_wr_completion_workers still need WQ_MEM_RECLAIM.
However scrub_nocow_workers does not need WQ_MEM_RECLAIM flags.

Did you mean this?

If you didn't mean this, would you please tell me why the WQ_MEM_RECLAIM 
is not
needed?

Thanks

Qu
>
> * WQ_FREEZABLE should be probably set
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


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

