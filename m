Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C565443AB4
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185528; cv=none; b=V3/P29aRS7qJO9WvOTG22CXfzQQ7YT1IlvmotuNMnY9MHsUZTuAEtucN3v0f025pndtPOQoQQQKp2ioik9xHdOkcupRvYPc3+lPpbemgSpe3WgCKRZ07k5Eg5BKAiDX+ZekColWeO2NZ5/ISVZ4I34i1d1nJ8OYlmYvcocKvyRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185528; c=relaxed/simple;
	bh=qeMdGEKedWl1FPeoapg8nysRoTiyOSWg/nAFOX53SYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upW9dmai1CZqd96xmevvhvY8Y+NpTOMM4JEePw/bFnI7jORGlYWIquIvV3nkY87aGNsfly91zJyY8d6Qmthk4vi84y4sR/7zY8o5nGjOj9DYyBsyWC5uKJIz4UYT2nqCRVL6oG6Wn9AvXiqj+WjnNrmBHlwV1pvCFGPuQQK7RVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UpySgTxB; arc=none smtp.client-ip=95.215.58.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UpySgTxB"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qeMdGEKedWl1FPeoapg8nysRoTiyOSWg/nAFOX53SYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788185524; v=1; x=1788790324;
 b=UpySgTxB7rkxUGIyTpQnQIDRnAUoPGeDYZFzZECpxJvXHmpZxm3bwcfx5EYnMnsVdYEBOYwa
 iu01b13XW9kL8gEQd9HmWD5Y8i8so2ASmXRCDFz73mNWh9S7xSpbLxxHF4uc9GXR/ezP/Q+SGPU
 7WbKYyaxgv7iBNoEUydmSMWs=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0c74ffbab702f936;
	Mon, 31 Aug 2026 14:11:54 +0000
X-Mizu-Trace-ID: 0c74ffbab702f936
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: penguin-kernel@i-love.sakura.ne.jp,
	brauner@kernel.org
Cc: Markus.Elfring@web.de,
	axboe@kernel.dk,
	broonie@kernel.org,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	hch@infradead.org,
	hch@lst.de,
	hdanton@sina.com,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	oliver.sang@intel.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v7] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Mon, 31 Aug 2026 22:11:43 +0800
Message-ID: <20260831141143.704821-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
References: <6a770a9c-2642-4392-9b9c-609836693f36@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Tao Cui <cuitao@kylinos.cn>=0D

Hi Tetsuo, Bart,=0D
=0D
> +	/* Step 1: Flush all outstanding I/O, without open_mutex held. */=0D
> +	/*=0D
> +	 * Now that loop_queue_rq() sees lo->lo_state !=3D Lo_bound,=0D
> +	 * wait for already started loop_queue_rq() to complete.=0D
> +	 */=0D
> +	synchronize_rcu();=0D
=0D
Your reply to Bart says loop_queue_rq() is called with RCU read=0D
lock, but I don't see one.  The two call sites of ->queue_rq() are=0D
blk_mq_dispatch_rq_list() and __blk_mq_issue_directly(), and=0D
neither is wrapped in rcu_read_lock().  Direct issue from=0D
blk_mq_submit_bio() runs in process context with no RCU read-side=0D
critical section, so synchronize_rcu() does not wait for a=0D
loop_queue_rq() that is already running there.  Only the softirq=0D
dispatch path is an implicit RCU reader.=0D
=0D
The window is still closed by the steps below, so this is not a=0D
correctness bug, but the synchronize_rcu() is not doing what the=0D
comment claims.  blk_mq_quiesce_queue() +=0D
blk_mq_wait_quiesce_done(), as Bart suggested, would express the=0D
intent directly.=0D
=0D
> +	/*=0D
> +	 * Now that no more AIO requests are scheduled by lo_rw_aio(),=0D
> +	 * wait for already started AIO to complete.=0D
> +	 */=0D
> +	blk_mq_unfreeze_queue(lo->lo_queue, blk_mq_freeze_queue(lo->lo_queue));=
=0D
=0D
About this step, in your follow-up you wrote:=0D
=0D
>   (1) since we are in lo_release() with disk_openers(disk) =3D=3D 0, the =
activity of=0D
>       incrementing/decrementing q_usage_counter (incremented before loop_=
queue_rq()=0D
>       is called, and decremented after loop_queue_rq() returned BLK_STS_I=
OERR)) will=0D
>       cease shortly=0D
=0D
The decrement timing here is only true for the error path.  For=0D
BLK_STS_OK the reference is held until the request is freed, which=0D
is what makes blk_mq_freeze_queue() wait for requests that already=0D
passed the state check, including the loop workqueue worker that=0D
completes them.  That is the property step 1 relies on, and it is=0D
worth stating in the comment.=0D
=0D
What is still open is Bart's question about io_uring fixed files:=0D
if submissions can continue after the last close, "cease shortly"=0D
does not hold, and it is the freeze wait that actually drains them.=0D
=0D
> +	if (need_clear) {=0D
> +		/*=0D
> +		 * Grab all references that will be dropped as soon as=0D
> +		 * returning from lo_release() and releasing disk->open_mutex.=0D
> +		 */=0D
> +		get_device(disk_to_dev(disk));=0D
> +		__module_get(disk->fops->owner);=0D
> +		queue_work(system_long_wq, &lo->lo_clr_work);=0D
> +	}=0D
=0D
With teardown now asynchronous, between the last close()=0D
returning and the work item finishing, lo_open() and=0D
LOOP_CONFIGURE return -ENXIO.  That is the same behavior change=0D
that led to the revert of the earlier attempt (bf23747ee053,=0D
xfs/259).  Moving the xfstests side to the tests is one thing, but=0D
userspace that closes a loop device and immediately reconfigures=0D
it now needs to handle a transient -ENXIO.  Is that acceptable, or=0D
should the retry happen in the kernel?=0D
=0D
Thanks,=0D
Tao=0D
