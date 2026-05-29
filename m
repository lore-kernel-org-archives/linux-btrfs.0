Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC3C351C1F
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.135.153.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780038310; cv=none; b=QdcHoxf/krM/yDXdqiEoz/Imfaq+IL9Eapvo5LIz3HcAkd6rQgHO3TC+y2kLhmJitu+F+AAJjdI2pYkMF2GgDvHOJsJuddRgk9Jhl68VOkq9N+7JYzMVIxFNUF51y1w+YtvD9+1+LgHbftxb9aUImS59a4IU1JtjzrDhp3EjgWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780038310; c=relaxed/simple;
	bh=QJBPhTdn+jjhlbB5sPkQIha3ypdO5+Koy6MfhAQgOWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTMM/ufv1TznZmt5wmTJGUate4FT4Tjvj5d2Jb1RJ+1gs6ouAGWYV71sK1cIzgRW8FR8BqC6kfPuSwEcfu/+LobOA5WsSPISpJotDaoCZoIhXEBGyi6shCpVShEB+1c+EfnU3l9dGo1H7J7kSUMi1gCyBB5V897CL32nFL9ZS4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=JCisxEKB; arc=none smtp.client-ip=61.135.153.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="JCisxEKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780038305;
	bh=I/cvswV/b0UR4VjhlDE/PSQobnVxd2Hh74IJsbGpfyw=;
	h=From:Subject:Date:Message-ID;
	b=JCisxEKBe8UfFjtODYkgsZanCX+X/FwjrhldJ63+bCXfue/0frSrAhs+7qO60yFpL
	 L5c9+CNet6EwwnlVqUBncbmZpFrUb16GM8QSpN/CcX4rtiYXGN9A+E4gprS+DNXasT
	 vPgfGKsE2QcGzfM0OBlcfJv0SyVc4FAZz5XKfqnY=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 6A193A7500003A64; Fri, 29 May 2026 15:04:23 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 2904214456667
X-SMAIL-UIID: 144996F36D3C4D3FBCBB600E4D7C0F5F-20260529-150423-1
From: Hillf Danton <hdanton@sina.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Fri, 29 May 2026 15:04:10 +0800
Message-ID: <20260529070411.1206-1-hdanton@sina.com>
In-Reply-To: <26717cb6-81b0-4d5d-a5db-669283f9bb9d@I-love.SAKURA.ne.jp>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 29 May 2026 09:14:47 +0900 Tetsuo Handa wrote:
>On 2026/05/29 8:00, Hillf Danton wrote:
>>> Given the loop workqueue that triggered the jfs warning, can you specify
>>> the reason why the workqueue in question is NOT flushed while closing disk?
>>>
>> Got it, the loop workqueue is NOT flushed to avoid deadlock, see d292dc80686a
>> ("loop: don't destroy lo->workqueue in __loop_clr_fd") for detail.
>> And the deadlock can be reproduced by flushing the loop workqueue with
>> disk->open_mutex held [1].
>> 
>> [1] Subject: Re: [syzbot] possible deadlock in blkdev_put (3)
>> https://lore.kernel.org/lkml/000000000000ea753505da2658d5@google.com/
>
>We can avoid the following lockdep warnings (including [1] you mentioned)
>
>  https://syzkaller.appspot.com/bug?extid=2f62807dc3239b8f584e
>  https://syzkaller.appspot.com/bug?extid=c4e9d077bcc86bee08dc
>  https://syzkaller.appspot.com/bug?extid=0f427123ae84b3ba6dc7
>  https://syzkaller.appspot.com/bug?extid=4feabfc9641267769c97
>  https://syzkaller.appspot.com/bug?extid=fb0ff9bfe34ad282ebd4
>
>caused by "drain_workqueue() with disk->open_mutex held" if we assign
>caller-specific lockdep class to disk->open_mutex
>
>  https://sourceforge.net/p/tomoyo/tomoyo.git/ci/c2245c765ebeba9dcb924d9171d8d470a9ac41c8/
>
>.
>
>Also, we can avoid lockdep warning caused by "drain_workqueue() with disk->open_mutex held" +
>"holding system_transition_mutex" if we forbid binding to pseudo files as backing file
>in the loop driver
>
>  https://lkml.kernel.org/r/d38e4600-3c32-491f-aa49-905f4fad1bfb@I-love.SAKURA.ne.jp
>
>which we can reproduce with
>
>  echo 7:0 > /sys/power/resume
>  losetup /dev/loop0 /sys/power/resume
>  cat /dev/loop0 > /dev/null
>  losetup -d /dev/loop0
>
>.
>
>Therefore, I think we can address this problem by "drain_workqueue() with disk->open_mutex
>held" in the loop driver side.
>
Good news.
>
>
>However, the possibility that the last milli-second writeback request
>(which runs during unmount operation) from filesystem fails due to
>
>    if (data_race(READ_ONCE(lo->lo_state)) != Lo_bound)
>        return BLK_STS_IOERR;
>
>check in loop_queue_rq() will remain.

This conflicts with "There is no need to destroy the workqueue when
clearing unbinding a loop device from a backing file." in d292dc80686a

>Therefore, addressing this problem
>within individual filesystem will be more strict solution. But guessing from

Conflicts with "Another thing is, if it's some btrfs bios on-the-fly after 
close_ctree(), the most common symptom should be NULL pointer 
dereference inside various btrfs endio functions." [2] once more.

And you need to pay the fs guys more than two cents I think for cooking
a FIX.

[2] Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
https://lore.kernel.org/lkml/36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com/

>the pace jfs fixes bugs, it would take long time before we stop seeing
>this problem...
