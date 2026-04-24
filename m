Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD233C18B
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 22:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068702; cv=none; b=WDorcjIg2OafMOuOlGVZU21iVx4ZVNjTOOfDQmpJN/dteBJ9vWd/9jnS1qgF/4nYlEUJjFPfV/y2Nz1frdrVMGJpaqagiGkwLTZcSSh2cW4vNEVXSx29MqfONUlYlVQly09W22NkIoolH5nLziqJ9hlDfVuR0u5Y7hoBvXK0fRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068702; c=relaxed/simple;
	bh=oeiMfmF5QfnHXVUz7jxvLc0iGwheKx+mPzCEeK/VS68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0dH+xzVmXOTAA1983u/XNpwnBgsTPT0hA4qS4ow9ly//HVx1/684svK2CE0Fn05d7dbVXzF06j1u/phoodWvh7tzTr8hrVqbGAVJ6ULiLwedWpK/hL206OpadLvxTZ60nDfApSVstXOQemil900ztFJdHkpHB1GUBYpPw+eMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=K6LNKhpy; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fYlQ1BvQ; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="K6LNKhpy";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fYlQ1BvQ"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 68247EC053E;
	Fri, 24 Apr 2026 18:11:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 24 Apr 2026 18:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1777068699;
	 x=1777155099; bh=mWuS/vzR0ouaFIG31zlpgmtupbfAukox5AkVt3NQybM=; b=
	K6LNKhpyijvYzxDxbisom/kdQfBfCjbLyxEZTa0tcQQ0Tlf8vOC3DrpiTNuCyJKz
	AzE0yMifdgQgx1zaj5qFT6Od+PFZExJ23zcQQqicFK+yUK3/NDJvHgBkIhWPCgkl
	WD+FlWKntxu1eq5UohdixXPgHHQoT208oHsiYOxRx+MxvlUAPZu8gzG3m9tbVMku
	LQ6WVx6ueXJCIqje2cSBWeLnFcAWq9yPGsafw8u/0oR9cWllMaVCtRNpCFMrDuPa
	xhRdfKyWSh+J7y5NstNan+wLVOV7hTvk6IH5yGGTGgBN83WQfU4ykrQDYm0WYnHj
	j4ap3dKSkLKfMjLdOPD1+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777068699; x=
	1777155099; bh=mWuS/vzR0ouaFIG31zlpgmtupbfAukox5AkVt3NQybM=; b=f
	YlQ1BvQZWPwZM60QZnRZ4SnLlFMpFMEDbD8Du0MLnT4LQ0aJdBhaSusC4ut7cx8w
	JZ76t2DoYioxjShgB9Fs+ATAkQqLuN83kq7sUBVz6efin2f2CEENLfV3Ihr7FhsI
	+GpeqWDyD1bY+70vmNQQf87HPs7xx1Jtp+OQDyxXWn/mxG1Jo5Qvj7mYi8w0uRjT
	GX+jo5U4Dmn0MHAB2k+Ekhbfoqw4vCVv4Tia6aONNAm9teT8wSo+GaALxzHH42L0
	h/qo0WuOFmoTwh5/bea9x0biO6BRanZZ4RqgVH09iJmUsImKoUOXfcf2ubqF82Ne
	2IZFtCHT8VzZQMK1IwQig==
X-ME-Sender: <xms:m-rraY_DQSYIr-E7LOWTwgL1UWllWhlxOdWGF7ITtJXSMDfDbIsW1w>
    <xme:m-rraYK1WFuJN6yEzZAvXq75drCiej-5sW4cDXInSqohbrDsNZ0JTKCPKlHbGXVlT
    cYjLye_nT_WjT9rZitM83EJmzcw-27vXRHS0mrWDLfEgsj6vPhFc0E>
X-ME-Received: <xmr:m-rrabYcLty8HBrmE_HeaIr_sbd8V0bdbCWqs4xTxwGOrfOpr7fD3ZjrJuXs98_DafBk2nEz9TgAcFkQ9TGjrQHp2j4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejuddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertd
    dttdejnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudelhfdthfetuddvtefhfedtiedtteehvddtkedvle
    dtvdevgedtuedutdeitdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhm
    gidrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:m-rraSJBAGK6SVjjnyQVL2KyAlE1cSzTfVtzZ1xt8NS7Ely4n6YrCw>
    <xmx:m-rraRDDWebcwFq_LzHEpnJLtJgvyViYHAu-UNnt-txyIqgRb2Fyaw>
    <xmx:m-rrafruyXaihSwmkcARVdey3Wv3vPhNl8LZDiN0HFSVS74MOPgnIw>
    <xmx:m-rraUhm-ohO_lJdv1_6VZp4kMQq5XL6mQ7PQpzqCy-0pVHdc-q5fQ>
    <xmx:m-rraatqXQDDEWh9LQZBHIRqVlrysvcA_qAwu1-n4dGv3hqDoRs36k8q>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 18:11:38 -0400 (EDT)
Date: Fri, 24 Apr 2026 15:10:59 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
Message-ID: <20260424221059.GA2970690@zen.localdomain>
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
 <20260424201054.GA2801466@zen.localdomain>
 <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>

On Sat, Apr 25, 2026 at 07:36:49AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/25 05:41, Boris Burkov 写道:
> > On Fri, Apr 24, 2026 at 07:37:38PM +0930, Qu Wenruo wrote:
> [...]
> > > 
> > > Furthermore, even with this particular patch *reverted*, I'm still seeing
> > > generic/224 hitting the same problem.
> > > 
> > > Currently I'm testing at the commit before the whole series, which is
> > > "btrfs: abort transaction in do_remap_reloc_trans() on failure", and no
> > > generic/224 hang nor 100% kworker CPU usage.
> > > 
> > > Thus I'm afraid the whole series may be involved.
> 
> Sorry, at least on my arm64 machine, the first 3 patches are not the root
> problem.
> 
> In fact on v7.0-rc7, I can still hit generic/224 hang, aka kernel detects
> 120s time out for hung processes, and my VM is configured to reset after
> such detection.
> 
> I'm going to slightly loose the hung task detection time (120s->150s) and
> check if it's just too slow in this particular case.
> 
> 
> Although the last patch is still causing excessive CPU usage here, and very
> reliably.
> 
> > > 
> > > Thanks,
> > > Qu
> > > 
> > 
> > Now that I have had a good chance to try and repro, here is what I have
> > seen so far on my desktop x86 machine and a cloud arm machine.
> > 
> > x86:
> > a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on failure")
> >    consistently done in 1 second
> > 8099a837f487 ("btrfs: cap shrink_delalloc iterations to 128M")
> >    finishes, but in ~500s
> > ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
> >    finishes, but in ~500s
> > 
> > arm:
> > a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on failure")
> >    consistently done in ~300 seconds
> > ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
> >    done in ~600s
> > 
> > The two inconsistencies are that I didn't see it go fast on g/027 with just
> > the shrink_delalloc iterations patch reverted, and I don't have a 2
> > second baseline on my arm setup.
> 
> At least we got something that both of us can reproduce.
> 
> Another thing is, for g/027 on arm64 I'm also actively monitoring the CPU
> usage through top.
> 
> Have you experienced very high (~100%) CPU usage on a kworker during g/027?
> 

No :(
As far as I can tell the system is stuck waiting on a commit. I'll keep
trying to repro your symptom.

I'm curious if it goes away for you with Sun's proposed fix, something
like setting pages to at least 1 after those to min() operations.

Such a patch had no impact on the behavior of either of my systems,
though.

> That's the most reliably symptom on my arm64 systems, and that's the
> criteria I used to bisect, as it takes less than 5 seconds to determine if
> it's good or not.
> 
> > 
> > So I agree that this patch series effectively breaks those tests, on x86
> > as well. I didn't notice the change in runtime, unfortunately, as I only
> > looked for success/failure.
> > 
> > As to the cause:
> > Both g/027 and g/224 are explicitly testing lots of writes to a small
> > filesystem.
> > 
> > I suspect that what is happening is what Filipe warned about with
> > excessive space reclaim/pinning reclaim/etc. choking the workload
> > due to excessive reservation. I have played around with reducing the
> > reservation sizes in various ways (set it back to 0, set the level
> > estimate to 4 as test, etc.) and the result varies from back to full
> > speed or a 60s run. So in my setup, at least, it looks like the
> > performance of g/027 is very sensitive to how much we reserve.
> 
> At least to me, the biggest problem is the 100% CPU usage of the kworker,
> which indicates a pretty bad dead looping.
> 
> > 
> > Would you be willing to let it run for 5-10m to see if you also
> > reproduce this behavior?
> 
> Unfortunately it didn't even finish after 15m here.
> And there is the dmesg with time stamps, the calltrace is triggered by
> "echo l > /proc/sysrq-trigger".
> 
> [   30.140269] run fstests generic/027 at 2026-04-25 07:19:32
> [   30.392655] BTRFS: device fsid 85ba0f7c-dfed-4220-9d47-72b07a1c81d8 devid
> 1 transid 8 /dev/mapper/test-scratch1 (253:2) scanned by mount (1108)
> [   30.395605] BTRFS info (device dm-2): first mount of filesystem
> 85ba0f7c-dfed-4220-9d47-72b07a1c81d8
> [   30.395625] BTRFS info (device dm-2): using crc32c checksum algorithm
> [   30.398590] BTRFS info (device dm-2): checking UUID tree
> [   30.398734] BTRFS info (device dm-2): turning on async discard
> [   30.398737] BTRFS info (device dm-2): enabling free space tree
> [   33.294754] systemd-journald[360]: Time jumped backwards, rotating.
> [  993.736548] sysrq: Show backtrace of all active CPUs
> [  993.736581] NMI backtrace for cpu 0
> [  993.736608] CPU: 0 UID: 0 PID: 2410 Comm: bash Not tainted
> 7.0.0-rc7-custom-64k+ #10 PREEMPT(full)
> [  993.736613] Hardware name: QEMU KVM Virtual Machine, BIOS unknown
> 2/2/2022
> [  993.736616] Call trace:
> [  993.736618]  show_stack+0x20/0x38 (C)
> [  993.736635]  dump_stack_lvl+0x60/0x80
> [  993.736646]  dump_stack+0x18/0x24
> [  993.736649]  nmi_cpu_backtrace+0xf0/0x128
> [  993.736665]  nmi_trigger_cpumask_backtrace+0x1c4/0x1f8
> [  993.736668]  arch_trigger_cpumask_backtrace+0x20/0x40
> [  993.736675]  sysrq_handle_showallcpus+0x24/0x38
> [  993.736686]  __handle_sysrq+0x9c/0x1b8
> [  993.736689]  write_sysrq_trigger+0xcc/0x100
> [  993.736692]  proc_reg_write+0x7c/0xf0
> [  993.736701]  vfs_write+0xd8/0x3a8
> [  993.736716]  ksys_write+0x70/0x120
> [  993.736719]  __arm64_sys_write+0x20/0x40
> [  993.736722]  invoke_syscall.constprop.0+0x64/0xe8
> [  993.736726]  el0_svc_common.constprop.0+0x40/0xe8
> [  993.736728]  do_el0_svc+0x24/0x38
> [  993.736730]  el0_svc+0x3c/0x198
> [  993.736733]  el0t_64_sync_handler+0xa0/0xe8
> [  993.736735]  el0t_64_sync+0x198/0x1a0
> [  993.736755] Sending NMI from CPU 0 to CPUs 1-7:
> [  993.736769] NMI backtrace for cpu 3
> [  993.736777] CPU: 3 UID: 0 PID: 212 Comm: kworker/u38:2 Not tainted
> 7.0.0-rc7-custom-64k+ #10 PREEMPT(full)
> [  993.736780] Hardware name: QEMU KVM Virtual Machine, BIOS unknown
> 2/2/2022
> [  993.736782] Workqueue: events_unbound btrfs_async_reclaim_metadata_space
> [btrfs]
> [  993.736879] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS
> BTYPE=--)
> [  993.736882] pc : _raw_spin_unlock_irqrestore+0x10/0x60
> [  993.736899] lr : __percpu_counter_sum+0x94/0xc0
> [  993.736909] sp : ffff8000834cfc10
> [  993.736910] x29: ffff8000834cfc10 x28: 0000000000000400 x27:
> 0000000008000000
> [  993.736912] x26: ffff0000ccfef81c x25: 0000000000000000 x24:
> ffffb6b45621ef98
> [  993.736914] x23: ffff0000d2e48698 x22: ffffb6b45621a000 x21:
> ffffb6b456219080
> [  993.736916] x20: ffffb6b456219288 x19: 0000000000009000 x18:
> ffff494da90b0000
> [  993.736917] x17: 0000000000000000 x16: ffffb6b45524e920 x15:
> ffffb6b45621ef98
> [  993.736919] x14: ffffb6b456111740 x13: 0000000000000180 x12:
> ffff0001ff1c1740
> [  993.736921] x11: 00000000000000c0 x10: 4eb904daffc7d416 x9 :
> ffffb6b45524e9b4
> [  993.736922] x8 : ffff8000834cfab0 x7 : 0000000000000000 x6 :
> ffffffffffffffff
> [  993.736924] x5 : 0000000000000000 x4 : 0000000000000000 x3 :
> 0000000000000008
> [  993.736926] x2 : 0000000000000008 x1 : 0000000000000000 x0 :
> ffff0000d2e48698
> [  993.736928] Call trace:
> [  993.736929]  _raw_spin_unlock_irqrestore+0x10/0x60 (P)
> [  993.736932]  flush_space+0x45c/0x6b0 [btrfs]
> [  993.737001]  do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
> [  993.737064]  btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs]
> [  993.737126]  process_one_work+0x174/0x540
> [  993.737138]  worker_thread+0x1a0/0x318
> [  993.737140]  kthread+0x140/0x158
> [  993.737145]  ret_from_fork+0x10/0x20
> [  993.737156] NMI backtrace for cpu 4
> 
> > 
> > I will try to instrument the reservations and reclaim codepaths and see
> > if I can think of a nice fix to reserve "enough but not too much".
> > 
> > I can also try to attack the "stuck big fs under big reclaim" more
> > directly by trying to make reclaim less stuck-prone, rather than messing
> > with reservations. Though it would be quite disappointing if we
> > practically cannot make the reservation choices more accurate..
> 
> Totally understandable, ENOSPC in btrfs is always the biggest challenge, and
> the trade-offs are always hard to balance.
> 
> Meanwhile I'd prefer to have the last commit reverted so that we can
> continue our regular testing.
> 
> Thanks,
> Qu
> 

Totally agreed. I'm going to revert the whole series till I understand
what happened here.

Thanks,
Boris

> > 
> > Thanks,
> > Boris
> > 
> > > > 
> > > > Do you have any clue on what's going wrong? I guess it's pretty hard to
> > > > hit on x86_64.
> > > > 
> > > > I have a local btrfs branch with huge folios support, with that it's
> > > > pretty easy to hit similar problems on x86_64, but without that branch,
> > > > no hit is observed so far on x86_64.
> > > > 
> > > > Thanks,
> > > > Qu
> > > > 
> > > > > ---
> > > > >    fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
> > > > >    1 file changed, 20 insertions(+), 11 deletions(-)
> > > > > 
> > > > > diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> > > > > index f0436eea1544..e931deb3d013 100644
> > > > > --- a/fs/btrfs/space-info.c
> > > > > +++ b/fs/btrfs/space-info.c
> > > > > @@ -725,9 +725,8 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >        struct btrfs_trans_handle *trans;
> > > > >        u64 delalloc_bytes;
> > > > >        u64 ordered_bytes;
> > > > > -    u64 items;
> > > > >        long time_left;
> > > > > -    int loops;
> > > > > +    u64 orig_tickets_id;
> > > > >        delalloc_bytes = percpu_counter_sum_positive(&fs_info-
> > > > > > delalloc_bytes);
> > > > >        ordered_bytes = percpu_counter_sum_positive(&fs_info-
> > > > > > ordered_bytes);
> > > > > @@ -735,9 +734,7 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >            return;
> > > > >        /* Calc the number of the pages we need flush for space
> > > > > reservation */
> > > > > -    if (to_reclaim == U64_MAX) {
> > > > > -        items = U64_MAX;
> > > > > -    } else {
> > > > > +    if (to_reclaim != U64_MAX) {
> > > > >            /*
> > > > >             * to_reclaim is set to however much metadata we need to
> > > > >             * reclaim, but reclaiming that much data doesn't really track
> > > > > @@ -751,7 +748,6 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >             * aggressive.
> > > > >             */
> > > > >            to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
> > > > > -        items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
> > > > >        }
> > > > >        trans = current->journal_info;
> > > > > @@ -764,10 +760,14 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >        if (ordered_bytes > delalloc_bytes && !for_preempt)
> > > > >            wait_ordered = true;
> > > > > -    loops = 0;
> > > > > -    while ((delalloc_bytes || ordered_bytes) && loops < 3) {
> > > > > -        u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
> > > > > -        long nr_pages = min_t(u64, temp, LONG_MAX);
> > > > > +    spin_lock(&space_info->lock);
> > > > > +    orig_tickets_id = space_info->tickets_id;
> > > > > +    spin_unlock(&space_info->lock);
> > > > > +
> > > > > +    while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
> > > > > +        u64 iter_reclaim = min_t(u64, to_reclaim, SZ_128M);
> > > > > +        long nr_pages = min_t(u64, delalloc_bytes, iter_reclaim) >>
> > > > > PAGE_SHIFT;
> > > > > +        u64 items = calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
> > > > >            int async_pages;
> > > > >            btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> > > > > @@ -811,7 +811,7 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >                   atomic_read(&fs_info->async_delalloc_pages) <=
> > > > >                   async_pages);
> > > > >    skip_async:
> > > > > -        loops++;
> > > > > +        to_reclaim -= iter_reclaim;
> > > > >            if (wait_ordered && !trans) {
> > > > >                btrfs_wait_ordered_roots(fs_info, items, NULL);
> > > > >            } else {
> > > > > @@ -834,6 +834,15 @@ static void shrink_delalloc(struct
> > > > > btrfs_space_info *space_info,
> > > > >                spin_unlock(&space_info->lock);
> > > > >                break;
> > > > >            }
> > > > > +        /*
> > > > > +         * If a ticket was satisfied since we started, break out
> > > > > +         * so the async reclaim state machine can process delayed
> > > > > +         * refs before we flush more delalloc.
> > > > > +         */
> > > > > +        if (space_info->tickets_id != orig_tickets_id) {
> > > > > +            spin_unlock(&space_info->lock);
> > > > > +            break;
> > > > > +        }
> > > > >            spin_unlock(&space_info->lock);
> > > > >            delalloc_bytes = percpu_counter_sum_positive(
> > > > 
> > > > 
> > > 
> 
