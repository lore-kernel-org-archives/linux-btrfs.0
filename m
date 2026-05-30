Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FBB25A2C6;
	Sat, 30 May 2026 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780185479; cv=none; b=qlYMHEDPeMU/3mYAsiNXfj1tMlY3hbNDd36kXY5WXCOl4QuW44yeo8dYUR5rFxfHoPIo1R0iDr2jpmEy1IMVV+RqjSUHVCv1M3z4AyZFuubPD8pqIjj2e0uwATChzRSZ0zs5oeFzAiMUeCRovF2Jc2x4D+VOu3BlANrPOH3GGio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780185479; c=relaxed/simple;
	bh=P+ARwgwPDAQi8TDWl1HgbllaUnzFrBzBr8U8EqvzhWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fskbUqXQnvdv8XDpnGW3UhQWLwB1lB7O9xoBwZXY8jwDGXWFMonBfDVd70IzgIWJ1dYt3U3/0CEuZaP+R3Xbss2vSQNSGXvhmVy3VOMnCE1POGJEXK+eA0RQqhztXLP5E9HFlIfAYmsIewz5bSfM8QSWSGU33RIomxATI+L0dlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64UNvYTZ074013;
	Sun, 31 May 2026 08:57:34 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64UNvYqK074010
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 31 May 2026 08:57:34 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
Date: Sun, 31 May 2026 08:57:33 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Hillf Danton <hdanton@sina.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>
References: <20260529220600.1226-1-hdanton@sina.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260529220600.1226-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav402.rs.sakura.ne.jp

On 2026/05/30 7:05, Hillf Danton wrote:
>>> Therefore, I think we can address this problem by "drain_workqueue() with disk->open_mutex
>>> held" in the loop driver side.
>>>
>> Good news.
>>
> Bad news: Subject: [syzbot] [block?] possible deadlock in loop_process_work
> [3] https://lore.kernel.org/lkml/6a19f5f7.5099cdd9.8e407.0004.GAE@google.com/
> 

OK. I sent two patches

  https://lkml.kernel.org/r/147ed056-03d9-4214-b925-0f10fc00cf27@I-love.SAKURA.ne.jp
  https://lkml.kernel.org/r/148efba2-a0b6-47d7-ac76-b19d2f4b696c@I-love.SAKURA.ne.jp

as a preparation for evaluating the possibility of calling drain_workqueue() from
__loop_clr_fd(). But as far as syzbot has tested using linux-next tree

  https://syzkaller.appspot.com/bug?extid=c4e9d077bcc86bee08dc
  https://syzkaller.appspot.com/bug?extid=4feabfc9641267769c97

seems to remain even if we applied above patches.

Therefore, I think that we need to call drain_workqueue() from __loop_clr_fd()
without holding disk->open_mutex (if we address this NULL pointer dereference
problem by updating the loop driver).

"[PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()" was an attempt to call
drain_workqueue() from __loop_clr_fd() without holding disk->open_mutex, but Sashiko's
review ( https://sashiko.dev/#/patchset/fda8abc8-6aa2-463b-bf72-865f6b838034%40I-love.SAKURA.ne.jp )
mentioned that the "module_put(THIS_MODULE);" executed as the last step of __loop_clr_fd() has
a race window of concurrently triggering module unload operation because module refcount of
the loop driver can become 0 due to this module_put(THIS_MODULE) call. In other words,
we cannot safely manage refcount of the loop module without a support by the caller of
lo_release() (i.e. bdev_release()).

  void bdev_release(struct file *bdev_file)
  {
  (...snipped...)
  	if (bdev_is_partition(bdev))
  		blkdev_put_part(bdev);
  	else
  		blkdev_put_whole(bdev);
  	mutex_unlock(&disk->open_mutex); // <= Keeping holding disk->open_mutex until __loop_clr_fd() completes causes circular locking problem.
  
  	module_put(disk->fops->owner); // <= Calling after __loop_clr_fd() completed is required for managing module refcount safely.
  put_no_open:
  	blkdev_put_no_open(bdev);
  }

Therefore, I think that the only robust and safe approach is, although you won't be
happy to see layering violation / tricky code, either

  (a) allow __loop_clr_fd() to temporarily drop disk->open_mutex

or

  (b) add a new callback for the loop driver which is called between mutex_unlock(&disk->open_mutex) and module_put(disk->fops->owner)

. Jens, what do you think?

One might argue that this problem should be fixed on the filesystem side by
ensuring all filesystems wait for I/O requests safely. However, from the
perspective of defensive programming, the loop driver should be robust enough
to handle incomplete I/O serialization from underlying layers to prevent GPF.
Furthermore, without adding noisy debug printk() messages, it is extremely
difficult to pinpoint which specific layer or filesystem failed to wait for
the I/O requests.

