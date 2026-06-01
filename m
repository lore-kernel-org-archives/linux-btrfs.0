Received: from r3-21.sinamail.sina.com.cn (r3-21.sinamail.sina.com.cn [202.108.3.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B64533D6F7
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 21:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780350712; cv=none; b=tTfzbo2a3Ur8naRLDD5GzTKTIzriog/qrVxbuhPOR7NSCeKryvEpAIhV185cNzkT8SMM0ju+uHsMQaBB8GCI/Lfuim8mHL9uEeb0VWGnOpKT+JdGFd3F9hPGFVQs8RX+wmM0P1d+pRVT2l1I8GCYbAgVCR/Y9XNxvU/iH9GOa+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780350712; c=relaxed/simple;
	bh=WAZnLuKL4m+84MYIRzHZOpYJMzXYGL/7lQREjsNyMQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6ZXXI2aYfjrBS0Pt3kk91GZqU+ArQNl+dXoBPZJoIEmB1qt6XOmBMbJzSj8IfkGZYmQDlJRKr5JLRbLczCtRPwOdkz7exduYkwrZYpFfQV274U0HGrgtq4s4zIcqBKY6VJ2WQv08BzvVoYbnN9YtQGUnR8w8aktZOwfgHl/PjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=afhx2ysx; arc=none smtp.client-ip=202.108.3.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="afhx2ysx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780350709;
	bh=zXzW3XX8RZqVhkmrR/Gk6gc/2IISfIY2tXx/7L6FHlU=;
	h=From:Subject:Date:Message-ID;
	b=afhx2ysxT9O4EP0fzNjBrOspmY2LQ1DKOW47XPbGk4MKK9RE4MQTbfZOFsMtKOJSa
	 DdaRGxwZttHXBJxcx+UuelFyTP3pEcwxptqhZJek6rQrFPgINOqZO0zPxyJYeqPp5m
	 wdV1d9mAYLFtEH+37PVrlSlbEKIus0+H6naxsacU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.33) with ESMTP
	id 6A1DFEEA00003659; Mon, 2 Jun 2026 05:51:40 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 959696685158
X-SMAIL-UIID: DAD1829FCED34716B5F9A21E0845A313-20260602-055140-1
From: Hillf Danton <hdanton@sina.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Tue,  2 Jun 2026 05:51:26 +0800
Message-ID: <20260601215129.1375-1-hdanton@sina.com>
In-Reply-To: <CACVXFVOSm=VpYfxUEpYk4yC2N1uAoK=vbg_A=h51GXeeArzCpw@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 1 Jun 2026 10:29:25 -0500 Ming Lei wrote:
>On Thu, May 28, 2026 at 5:16 AM Qu Wenruo <wqu@suse.com> wrote:
>> 在 2026/5/28 18:08, Christoph Hellwig 写道:
>> > On Thu, May 28, 2026 at 03:11:05AM +0900, Damien Le Moal wrote:
>> >> It sounds like the VFS unmount call needs to have something that waits for
>> >> sync() to complete. Though, it really feels very strange that an FS can complete
>> >
>> > I don't think this is the VFS-controlled VFS file data writeback, which
>> > we wait on, but some kind of fs controlled metadata.  And yes, it looks
>> > like those file systems are buggy in that area.  We definitively had
>> > such bugs in XFS before and fixed them.
>> >
>> > e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against
>> > unmount")
>> Considering the xfs fix is pretty old, it's before the fix hint thus no
>> such mention in fstests.
>>
>> Do you happen to know which test case is for that fix?
>> I'd like to adapt it for btrfs as a reproducer.
>>
>> This syzbot report doesn't provide a reproducer.
>>
>>
>> Another thing is, if it's some btrfs bios on-the-fly after
>> close_ctree(), the most common symptom should be NULL pointer
>> dereference inside various btrfs endio functions.
>> As all those end_bbio_*() functions are referring to either fs_info or
>> inode/eb, thus if the fs is unmounted before the bio finished, they
>> should all cause use-after-free.
>>
>> The only exception is discard, which is using blkdev_issue_discard()
>> thus has no such reference to btrfs internal structure, but that's out
>> of my understanding.
>
> syzbot log shows the null-ptr-deref  is on WRITE, instead of DISCARD.
>
> https://syzkaller.appspot.com/bug?extid=cd8a9a308e879a4e2c28
>
> Adding WARN_ON(!lo->lo_backing_file) in loop_queue_rq() might capture
> this bio submission context if this req isn't issued via wq.
>
I suspect this makes $.02 sense given the check of Lo_bound upon queuing rq.

static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
		const struct blk_mq_queue_data *bd)
{
	struct request *rq = bd->rq;
	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
	struct loop_device *lo = rq->q->queuedata;

	blk_mq_start_request(rq);

	if (data_race(READ_ONCE(lo->lo_state)) != Lo_bound)
		return BLK_STS_IOERR;
