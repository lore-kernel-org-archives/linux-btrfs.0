Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF94070814
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 07:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769499667; cv=none; b=S6zQhHQMUUKaI3WpT+fJN3t8R3VUbs86/tPz3CmRD0IJjoZlsprZX46fY4RspD3XzHKeBi9pjHKLcgzi9GoO+g7WobcxPAVZ34oe27VIkB+uJmAVdt0HsueFL0HzcyPHA1YooLeQB3W3ITUp+resoxxLyV3pEay4CaxiSfK9BZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769499667; c=relaxed/simple;
	bh=9l53iR2/vqewEW9rfMYU8Z9SfBOMG2TjEgRZNTSLG1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POZEAUqFT6Hw8CF0QsJwvZdTCdE3CIR2lTtuWIZvSbxznT1PjZypoomxvc5eEa7Z3i/F7Le7yYoztRJq6JDC++zyJ2IseeyEIxiGbnTYFF3K33kkK8oiub3MsykGGpvA5qSt98keHcSLZDCG3hmSaiZhNwq2BfBFGEAQ3b4OWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=sB2vOnLh; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="sB2vOnLh"
Received: from vbm-jinbaohong.. (unknown [10.17.211.178])
	by mail.synology.com (Postfix) with ESMTPA id 4f0clX4rvSzGBWgRs;
	Tue, 27 Jan 2026 15:40:56 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1769499657; bh=9l53iR2/vqewEW9rfMYU8Z9SfBOMG2TjEgRZNTSLG1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sB2vOnLhZT9RVeOtAe/5qHQskpxmFuScrNIExicvA3kPIV34Q+z2mbk2JQ4/FA6DP
	 Z3MJgCgmwXZG5I+ZxbfwibovKTdRBkLb/Fr8sMymOsQWpWmPjYCq6cPd3iG87MQAJU
	 MKCyru5RWYufJJ7eZSM8Qx09i9Jz/JfoszbRweA0=
From: jinbaohong <jinbaohong@synology.com>
To: fdmanana@kernel.org
Cc: dsterba@suse.com,
	jinbaohong@synology.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com
Subject: Re: [PATCH v3 2/2] btrfs: continue trimming remaining devices on failure
Date: Tue, 27 Jan 2026 07:40:55 +0000
Message-Id: <20260127074055.781388-1-jinbaohong@synology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAL3q7H4=9vH3UP6=i1zTe7MVKf6aWAqEqb7i+Fmxoc3q4qDyKA@mail.gmail.com>
References: <CAL3q7H4=9vH3UP6=i1zTe7MVKf6aWAqEqb7i+Fmxoc3q4qDyKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

Hi Filipe,

> > @@ -6648,7 +6780,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >                 }
> >
> >                 start = max(range->start, cache->start);
> > -               end = min(range_end, btrfs_block_group_end(cache));
> > +               end = min(range_end, cache->start + cache->length);
> 
> Please don't do that. We should use the helper btrfs_block_group_end().
> Why did you do this change? This seems completely unrelated.
> 
> Otherwise it looks fine, thanks.

First, sorry about the unrelated change from btrfs_block_group_end() to
cache->start + cache->length in v3. That was an accidental leftover from
debugging - I'll make sure it's removed in v4.

Before sending v4, I'd like to discuss some behavior details about trim
error handling.

=== 1. Block Group Loop Interrupt Handling ===

Currently, block_group loop has the same problem:

  ret = btrfs_trim_block_group(...);
  if (ret) {
      bg_failed++;
      bg_ret = ret;
      continue;  // Doesn't break on user interrupt
  }

I think we should also break the block group loop on user interrupt,
similar to the device loop.

=== 2. First Error vs Last Error ===

Currently, both block_group and device loops store the last error.
I'm considering changing this to preserve the first error.
This would show the root cause rather than the most recent failure.
What do you think?

=== 3. ERESTARTSYS/EINTR and Error Code Precedence ===

After reconsideration, I think user interrupt (-ERESTARTSYS or -EINTR)
should NOT overwrite a previous device error (if any). For example, if
device A fails with -EIO, then user interrupts during device B, the
final dev_ret should be -EIO rather than -ERESTARTSYS/-EINTR.

=== 4. Scope of ERESTARTSYS to EINTR Conversion ===

> > @@ -6685,10 +6687,14 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >                 ret = btrfs_trim_free_extents(device, &group_trimmed);
> >
> >                 trimmed += group_trimmed;
> > +               if (ret == -ERESTARTSYS) {
> > +                       dev_ret = -ERESTARTSYS;
> 
> And either replace it with -EINTR.
> 
> Otherwise it looks fine, thanks.
> 
> > +                       break;
> > +               }
> >                 if (ret) {
> >                         dev_failed++;
> >                         dev_ret = ret;
> > -                       break;
> > +                       continue;
> >                 }
> >         }
> >         mutex_unlock(&fs_devices->device_list_mutex);

You mentioned the issue of -ERESTARTSYS. Could you clarify the intended
scope?

Option A: Convert all btrfs_trim_interrupted() paths to return -EINTR
          (changes in extent-tree.c and free-space-cache.c)

Option B: Only convert at btrfs_trim_fs() level before returning to
          user space, keeping -ERESTARTSYS internally.

Which approach do you prefer?

Thanks,
jinbaohong

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
