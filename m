Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab3FMDHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 23:07:12 -0400
Message-ID: <51B937A9.3020906@cn.fujitsu.com>
Date: Thu, 13 Jun 2013 11:08:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shyam Kaushik <shyam@zadarastorage.com>
Subject: Re: [PATCH 2/3] Btrfs: fix the deadlock between the transaction start/attach
 and commit
References: <51249468.6010004@cn.fujitsu.com> <CAOcd+r35uFwUsmRuLRR3eGkVcceP2QEimhrN7xxSnBzB-LWVyQ@mail.gmail.com> <512B3AE7.9090208@cn.fujitsu.com> <CAOcd+r2bKGSoyxSXtnDKH5d04kRT2qRpFAKX2Dz6As=Qc_fOtg@mail.gmail.com> <514FAD96.7040002@cn.fujitsu.com> <CAOcd+r1i+neaAb+3o6CSVboKK_P0WPrSoiPLGC8t0QeqFM-uAQ@mail.gmail.com> <CAOcd+r16WyKxpDchERq+cGcq1oaEk21BvDSKWBtLge6s3GU=xg@mail.gmail.com> <518B56F1.40909@cn.fujitsu.com> <CAOcd+r3t+_TCsUytsJn9CAK0=dLJ91_bPncw_q8A3n5hqnT2pQ@mail.gmail.com>
In-Reply-To: <CAOcd+r3t+_TCsUytsJn9CAK0=dLJ91_bPncw_q8A3n5hqnT2pQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 12 Jun 2013 23:11:02 +0300, Alex Lyakas wrote:
> I reviewed the code starting from:
> 69aef69a1bc154 Btrfs: don't wait for all the writers circularly during
> the transaction commit
> until
> 2ce7935bf4cdf3 Btrfs: remove the time check in btrfs_commit_transaction()
> 
> It looks very good. Let me check if I understand the fix correctly:
> # When transaction starts to commit, we want to wait only for external
> writers (those that did ATTACH/START/USERSPACE)
> # We guarantee at this point that no new external writers will hop on
> the committing transaction, by setting ->blocked state, so we only
> wait for existing extwriters to detach from transaction
> # We do not care at this point for TRANS_JOIN etc, we let them hop on
> if they want
> # When all external writers have detached, we flush their delalloc and
> then we prevent all the others to join (TRANS_JOIN etc)
> 
> # Previously, we had the do-while loop, that intended to do the same,
> but it used num_writers, which counts both external writers and also
> TRANS_JOIN. So the loop was racy because new joins prevented it from
> completing.
> 
> Is my understanding correct?

Yes, you are right.

> I have some questions:
> # Why was the do-while loop needed? Can we just delete the do-while
> loop as it was before, call flush_all_pending stuffs(),  then set
> trans_no_join and wait for all writers to detach? Is there some
> correctness problem here?
> Or we need to wait for external writers to detach before calling
> flush_all_pending_stuffs() one last time?

The external writers will introduce pending works, we need flush them
after they detach, otherwise we will forget to deal with them at the current
transaction just like the following case:

	Task1				Task2
	start_transaction
					commit_transaction
					  flush_all_pending_stuffs
        add pending works
        end_transaction
					  ...


> # Why TRANS_ATTACH is considered external writer?

- at most cases, it is done by the users' operations.
- if in_commit is set, we shouldn't start it, or the deadlock will happen.
  it is the same as TRANS_START/TRANS_USERSPACE.

> # Can I apply this fix to 3.8.x kernel (manually, of course)? Or some
> additional things are needed that are missing in this kernel?

Yes, you can rebase it against 3.8.x kernel freely.

Thanks
Miao
