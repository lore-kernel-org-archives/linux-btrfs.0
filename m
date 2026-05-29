Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986101714AA;
	Fri, 29 May 2026 00:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780013724; cv=none; b=oDpNMt9ERFgSH3QLi1LKqz/MRjJ28oR/MVYKeC75IaY7vX4oVIriwoWug+yRoA2fcYvn8synp19XGNJFnrtbP7Kf8vS/d6jr8TFJZUXx3eQecPkBqU/rJn247Rm8X2sGCW8DdQMLYV0mi1ZJFq3IN27vs7Faxwms7iIGqxL1DXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780013724; c=relaxed/simple;
	bh=EpvZhaOno4JjKFW3qDgv0sB8Dx++vx0nQZkD9rA/DHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJkbuIOX/vJEPqTfS4GowN144W3pI9oSuabxlH2gHUsxOdtOS9hnlg0rpH2lvEGyEl5zRW7kYH0xFBF5Hz5vGo7RDJNs589SRlaBVDTLjzPVaKthY6OjwzL7HLcaxw2Ax2CoITsBZyzF/CAvhuuaP+uenQkiTnia6GWP3e+1aWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64T0Eog6003575;
	Fri, 29 May 2026 09:14:50 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64T0EoYT003569
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 May 2026 09:14:50 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <26717cb6-81b0-4d5d-a5db-669283f9bb9d@I-love.SAKURA.ne.jp>
Date: Fri, 29 May 2026 09:14:47 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Hillf Danton <hdanton@sina.com>, Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
References: <20260528230050.1185-1-hdanton@sina.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260528230050.1185-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav303.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/05/29 8:00, Hillf Danton wrote:
>> Given the loop workqueue that triggered the jfs warning, can you specify
>> the reason why the workqueue in question is NOT flushed while closing disk?
>>
> Got it, the loop workqueue is NOT flushed to avoid deadlock, see d292dc80686a
> ("loop: don't destroy lo->workqueue in __loop_clr_fd") for detail.
> And the deadlock can be reproduced by flushing the loop workqueue with
> disk->open_mutex held [1].
> 
> [1] Subject: Re: [syzbot] possible deadlock in blkdev_put (3)
> https://lore.kernel.org/lkml/000000000000ea753505da2658d5@google.com/

We can avoid the following lockdep warnings (including [1] you mentioned)

  https://syzkaller.appspot.com/bug?extid=2f62807dc3239b8f584e
  https://syzkaller.appspot.com/bug?extid=c4e9d077bcc86bee08dc
  https://syzkaller.appspot.com/bug?extid=0f427123ae84b3ba6dc7
  https://syzkaller.appspot.com/bug?extid=4feabfc9641267769c97
  https://syzkaller.appspot.com/bug?extid=fb0ff9bfe34ad282ebd4

caused by "drain_workqueue() with disk->open_mutex held" if we assign
caller-specific lockdep class to disk->open_mutex

  https://sourceforge.net/p/tomoyo/tomoyo.git/ci/c2245c765ebeba9dcb924d9171d8d470a9ac41c8/

.

Also, we can avoid lockdep warning caused by "drain_workqueue() with disk->open_mutex held" +
"holding system_transition_mutex" if we forbid binding to pseudo files as backing file
in the loop driver

  https://lkml.kernel.org/r/d38e4600-3c32-491f-aa49-905f4fad1bfb@I-love.SAKURA.ne.jp

which we can reproduce with

  echo 7:0 > /sys/power/resume
  losetup /dev/loop0 /sys/power/resume
  cat /dev/loop0 > /dev/null
  losetup -d /dev/loop0

.

Therefore, I think we can address this problem by "drain_workqueue() with disk->open_mutex
held" in the loop driver side.



However, the possibility that the last milli-second writeback request
(which runs during unmount operation) from filesystem fails due to

    if (data_race(READ_ONCE(lo->lo_state)) != Lo_bound)
        return BLK_STS_IOERR;

check in loop_queue_rq() will remain. Therefore, addressing this problem
within individual filesystem will be more strict solution. But guessing from
the pace jfs fixes bugs, it would take long time before we stop seeing
this problem...

