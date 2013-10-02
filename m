Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3JBBt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 21:49:28 -0400
Message-ID: <524B7BD6.4090403@cn.fujitsu.com>
Date: Wed, 02 Oct 2013 09:50:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: Replace the btrfs_workers with kernel workqueue
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com> <20130912173718.GE6810@twin.jikos.cz> <523BE774.4070808@cn.fujitsu.com> <20131001145050.GJ18291@twin.jikos.cz>
In-Reply-To: <20131001145050.GJ18291@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 1 Oct 2013 16:50:50 +0200, David Sterba wrote:
> On Fri, Sep 20, 2013 at 02:13:08PM +0800, Qu Wenruo wrote:
>>> * WQ_MEM_RECLAIM for the scrub thread does not seem right
>> I think scrub_workers,scrub_wr_completion_workers still need WQ_MEM_RECLAIM.
>> However scrub_nocow_workers does not need WQ_MEM_RECLAIM flags.
>>
>> Did you mean this?
>>
>> If you didn't mean this, would you please tell me why the WQ_MEM_RECLAIM is
>> not
>> needed?
> Documentation says that threads that might be used in the memory reclaim
> path must use this flag, but I don't see how this applies to scrub
> threads. They're not writing out dirty data, though they may issue a
> write, but that's not their main purpose.
>
Thanks for your explain.

I understand now, and will remove the WQ_MEM_RECLAIM flagsin the recent 
V3 patches.

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

