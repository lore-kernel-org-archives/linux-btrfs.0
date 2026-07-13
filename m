Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F473F4DFB;
	Mon, 13 Jul 2026 12:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783944006; cv=none; b=qZ8jUorohqSPLU22Neh820IwF/tcEvsHen5vL4M0vzInj42yVh5XQTXYtJOeBmotkKaanYzHd6Y4YSwFQSD5ILR2k5fwdE6t++M1/djWeVIKzbK/I+78DfGbJMyk7xkYk81jTORYNLPa9B1k+H2/uc22S3MPnIcOxxLZXaJEmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783944006; c=relaxed/simple;
	bh=E4XXHskAiNQD3O1u2CGgK1Goz6ou1/QuNzdeSHFZFVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyLBq/NoRk9LyQHSGx06ZJZwE9wvT2vqTM5b4ncl9X29yfvrEbTW47QVZdlSH7FTnOnavxDly1lG9/WJmZYWI+VApoG3KV2FYFp6EXHfR77S64aSQ75e9n+xTp1PZXVmGp9Z9qFEHqJSYtMK4ef71nf8x3/23zTtXm+B89dDx4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 66DB2sXf017577;
	Mon, 13 Jul 2026 20:02:54 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 66DB2sD4017574
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 13 Jul 2026 20:02:54 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <33277fd6-0479-4f6c-bc21-f25f7179d2dc@I-love.SAKURA.ne.jp>
Date: Mon, 13 Jul 2026 20:02:52 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Hillf Danton <hdanton@sina.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
References: <20260713030500.538-1-hdanton@sina.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260713030500.538-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav301.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/07/13 12:04, Hillf Danton wrote:
> On Tue, 9 Jun 2026 18:50:13 +0100 Al Viro wrote:
>> On Sun, Jun 07, 2026 at 07:54:58PM +0900, Tetsuo Handa wrote:
>>> syzbot is reporting NULL pointer dereference in lo_rw_aio() [1][2].
>>> An analysis by the Gemini AI collaborator [3] considers that this problem
>>> is caused by a timing shift primarily exposed by commit 65565ca5f99b
>>> ("block: unify the synchronous bi_end_io callbacks"), along with helper
>>> refactorings like commit 92c3737a2473 ("block: add a bio_submit_or_kill
>>> helper").
>>>
>>> But due to difficulty of reproducing this race, discussion about what is
>>> happening and how to fix this problem is stalling. Also, we haven't
>>> identified how many filesystems are subjected to this problem.
>>>
>>> Therefore, this patch introduces a grace period for flushing pending I/O
>>> requests (which should be a good thing from the perspective of defensive
>>> programming) so that we won't hit NULL pointer dereference problem, and
>>> also emits BUG: message in order to help filesystem developers identify
>>> the caller of an I/O request that failed to wait for completion so that
>>> filesystem developers can fix such caller to wait for completion.
>>>
>>> Note that emitting BUG: message is enabled only if CONFIG_KCOV=y, for
>>> this check is a waste of computation resources for almost all users.
>>
>> Still breaks xfs/259, same as the version in next-20260605...
>>
> And syzbot report [1]
> 
> [1] https://lore.kernel.org/lkml/6a54399f.278cdcd2.e885.0023.GAE@google.com/

No. This report is from upstream tree where "loop: Fix NULL pointer dereference
in lo_rw_aio()" is not yet applied.

[  102.784602][ T5324] loop0: detected capacity change from 0 to 2048
[  102.837593][ T5324] Alternate GPT is invalid, using primary GPT.
[  102.841605][ T5324]  loop0: p2 p3 p7
[  102.939203][ T5285] I/O error, dev loop0, sector 408 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  102.947057][ T5324] loop0: detected capacity change from 0 to 512
[  102.951560][ T5287] I/O error, dev loop0, sector 208 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[  102.964277][ T5287] I/O error, dev loop0, sector 208 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  102.969633][ T5285] I/O error, dev loop0, sector 408 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[  102.979918][ T5285] Buffer I/O error on dev loop0p7, logical block 8, async page read
[  102.984620][ T5287] Buffer I/O error on dev loop0p3, logical block 8, async page read
[  103.009916][ T5287] udevd[5287]: inotify_add_watch(7, /dev/loop0p3, 10) failed: No such file or directory
[  103.014532][  T176] ==================================================================
[  103.018401][  T176] BUG: KASAN: slab-use-after-free in update_io_ticks+0xa9/0x280
[  103.022211][  T176] Read of size 8 at addr ffff88803236b9a8 by task kworker/u4:6/176
[  103.025664][  T176] 
[  103.026746][  T176] CPU: 0 UID: 0 PID: 176 Comm: kworker/u4:6 Not tainted syzkaller #0 PREEMPT(full) 
[  103.026761][  T176] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  103.026768][  T176] Workqueue: loop0 loop_rootcg_workfn

Al, can you reproduce your xfs/259 breakage and share kernel messages with
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=d908729e7467462bce1db3bc1bffec2e2d1f6c81 ?

I'm floating this patch in linux-next tree, but syzbot hasn't succeeded to hit
"BUG: %s/%u is doing I/O request on loop%d in Lo_rundown state.\n" message.
I think we need to send to upstream tree so that syzbot can hit this message within a few days.
To do so, we need to agree that your xfs/259 breakage should be addressed on the xfstests side.

