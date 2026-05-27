Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93545BD60;
	Wed, 27 May 2026 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779905470; cv=none; b=SnuiISOVk6hoZG3uvEYIjNFvyc+W1EqNAKwNCxFRFRU/lvgqu2SoMfVBkn55H730ahGSzahH9QAWVjOXdJj0eCVs3th459iwEKL75hnh0J3eBeLLZnJeXh4ny8M0V7tOIbhePWrd12wBn4oHM4jQnokO6PojS2V7tcc2/9BSrcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779905470; c=relaxed/simple;
	bh=FR3flEeJqppiUYRlGx6vob2K/t2fe/ABpe9P4OUT3rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WUbBMbW8noktmS4gfeEkwSprFNyY5H4vO3TCc/8/N1MDHlhLJTHzzf+R/jYLTmoOFnrdC1ebQ/FLKmcDkE3i3VFasMAcq2x5fQJAsOkOT4eelfUz51mYgdqO1WYybgX+aL5gBKeW4MhemZFlFQzEvR6zl46XaC1xw9tWm5uvkVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMBqLHic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMBqLHic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEA11F000E9;
	Wed, 27 May 2026 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779905468;
	bh=LFIe2Cvhhffxlia7PRRhk6Oq1yPn74HcL0RzVeZsFu0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PMBqLHicoHnSY8YX/dhlwcV+sVEjR5MIKwC5zESQKIZ4/3mqZw5Jl4lrMHPyLfkX7
	 +vQN7B/4NDpvX2y6E08p6QsFCJTes+Uv16U8Ld07P8JMtbjxzHw+8fmHc3fvUbDl7D
	 idoR6xpJGi1XpDfcr37hty2sGNKh3EEj/8VR61FEMDKqSCCIQElHLsfautttCsSx4x
	 ewQUJHtnsRJvONyGqwFIksan8pFjNtwmLyXKFQdTOVTolFYpFYF4g1++c+O3yXcxk2
	 KpPQTeZz16EjzOdCOtb2cjvdrrlO3N38Rf+mueMCMu6sO6CSXqO/UlPb+IGFWLYdpD
	 e6FVA4SGEuMsg==
Message-ID: <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org>
Date: Thu, 28 May 2026 03:11:05 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
 Christoph Hellwig <hch@lst.de>, linux-block <linux-block@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>
References: <ag0lS_CbKO9R5CV8@fedora>
 <94076bc9-2c09-4bb6-8468-b6b8af419cb9@I-love.SAKURA.ne.jp>
 <ag1nfIFcykmQHbkk@fedora>
 <1ab8c579-eb76-4227-8a72-6ec819135219@I-love.SAKURA.ne.jp>
 <ag1223nAa0wZ8ALC@fedora>
 <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp>
 <ahRocb0Vs_m6RF_O@fedora>
 <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>
 <ahZGxoI6oHQ_vSrx@fedora>
 <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp>
 <ahZeYQ0cLE1i8TGs@fedora>
 <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/27 20:29, Tetsuo Handa wrote:
> On 2026/05/27 12:00, Ming Lei wrote:
>> On Wed, May 27, 2026 at 10:35:56AM +0900, Tetsuo Handa wrote:
>>> On 2026/05/27 10:20, Ming Lei wrote:
>>>>> Of course we should try to figure out the root cause first, but how can we do?
>>>>
>>>> Definitely unexpected write IO(after umount & loop closed) from btrfs is more serious,
>>>> which may cause data loss, so CC btrfs list and maintainer.
>>>
> 
> I had a conversation with Google AI mode, and received the following response.
> 
> --------------------------------------------------------------------------------
> Technical Analysis: lo_rw_aio Null Pointer Dereference / UAF since v7.1-rc1
> 
> 
> 1. The Root Cause of the Timing Shift
> 
> This regression was introduced during the v7.1-rc1 merge window, primarily exposed by
> Commit 65565ca5f99b ("block: unify the synchronous bi_end_io callbacks"), along with
> helper refactorings like Commit 92c3737a2473 ("block: add a bio_submit_or_kill helper").
> 
> Prior to v7.0, the synchronous I/O completion path inherently contained execution lags (due
> to serialized completion handling and context switches) before notifying upper layers. This
> latency accidentally acted as a natural safety barrier. It ensured that by the time a file
> system completed its final sync_filesystem() and initiated umount, the loop driver's internal
> workqueue (lo_rw_aio) had already finished processing everything.
> 
> In v7.1, the unification and optimization of bi_end_io significantly minimized this latency.
> The filesystem now learns of "I/O completion" much faster. Consequently, highly-concurrent
> execution pipelines like btrfs or jfs proceed rapidly through kill_sb() and blkdev_put(),
> ultimately invoking lo_release() -> __loop_clr_fd() while the loop driver's backend kworker
> is still in the middle of executing the last sub-millisecond asynchronous file-backed I/O
> request.
> 
> 
> 2. Why the Block Layer's Built-in Quiesce/Freeze Fails
> 
> There is an implicit assumption that standard block layer freeze mechanisms (blk_mq_freeze_queue())
> protect the device lifetime during release. However, the v7.1 BIO helper refactoring introduced
> a synchronization gap:
> 
>   1. The filesystem triggers its final metadata or journal updates (e.g., txCommit in jfs or
>      delayed refcount updates in btrfs) right during the unmount/close boundary.
>   2. Due to the optimized execution path, these requests bypass the block layer's active
>      request-tracking metrics at the exact moment blk_mq_freeze_queue() or state validation
>      checks evaluated them as zero.
>   3. The block layer assumes the queue is safe and silent, allowing __loop_clr_fd() to
>      progress and nullify lo->lo_backing_file (or trigger fput()).
>   4. The leaked asynchronous kworker wakes up a fraction of a millisecond too late, attempts
>      to access lo->lo_backing_file or invokes kiocb_end_write() -> file_inode(), leading to
>      either a general protection fault (Null pointer dereference) or a Use-After-Free (UAF).
> 
> 
> 3. Why This Isn't Just an "Unexpected FS Bug"
> 
> While the write I/O originates from file systems like btrfs and jfs post-close, blaming the
> file systems entirely ignores the underlying infrastructure change. The core issue is that the
> block layer altered its synchronization behavior, breaking the barrier contract that
> VFS and file systems historically relied on during the device release path.
> 
> Papering over this inside individual file systems would require adding heavy, duplicated
> barriers inside every single filesystem's unmount path.

It sounds like the VFS unmount call needs to have something that waits for
sync() to complete. Though, it really feels very strange that an FS can complete
unmount without itself ensuring that there are no more IOs in flight. The
generic VFS layer cannot know what the FS needs to flush on unmount, so waiting
on a generic sync might not be enough.

It really feels like this is a btrfs and jfs issue, unless the same can be
reproduced with any file system (XFS, ext4, f2fs, ...).

Just my 2 cents.


-- 
Damien Le Moal
Western Digital Research
