Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793875280;
	b=Uh6il/gWQdjg8Hy0S40Aur72DZlTQY3R8aI+EIiNjxuMh8fCfYN3Im6NNEjaZxFuRIP2
	 if/ePSfzT9kJt9kNX0daxp0q08xc72OLnUfx7falEmxzYxlXwZ3ADpGKvV2crxWQOmirh
	 oECHpYk/QTrhKawXTS6B7wDdkdmf9LhF3ursGK6GJWjMfbaIV+yKq1HYoVphS5EAKpULY
	 +9MWNuiZZJudk7QsJnVxoPAIEEmWhfP2dGMlvGoX/Ui7Sc+SMcpPRoZlfI+lBtVXh2NQZ
	 FnVR+uEaW55MxK1oAixkF1V5Z3NdIlZV+PcBop5+myanv1evlqTvO43Wnja6tI8IQvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793875280;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EUwfItNbVxWuThy7+GfxliZb0cWbAWR22kcW0+kMz1o=;
	b=M+nBlwaCeVterwsOCiDL4J7fda59k7lom1jZfrWitKzDY3JnBMkMvq50JqVrR2Nz/tYP
	 FchqHKiX+nize0nWRy1Cfbldy3ctubQGu4b4D343+VZacXiRN7DiEC9/PKUHMbf2MHdfT
	 FNQWgARR52OZ/WHi7xpHNXaZ6RSxHK/qaUYFSptHLU6UKJapmw9rgqCbFHRUL5tPV0Tfo
	 QI2UilNTQ+dweJ3neMuFekYLnqdT0zlKBcb0BcVWn/or/xMyneWQtEu00GG0/RbUD5DQJ
	 sPdbAUlo5f/RAZIAX3+F3smShkwZh7Rp0e/ayWTYh4nNdzYq/PENyXnIKL5GcD0mt4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=E7Dfyo4i;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82622606A32C;
	Thu,  5 Nov 2026 10:41:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82622606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=E7Dfyo4i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=E7Dfyo4iUv4M44fkZunCC/9nPOeyAo/VZ92uhavBLwtfiZQ4dp1I3XNwFrL3DpjgQ4MSe/4Mgi7JB
	 DIHJeY3NCIjokCsf5cuUW2p2eDxW52AogudZa+Ivi7O8ZB277Y4Slv7yfHrrdeddJ/z1ykAS0bxwY4
	 YvienmYAs6Dw0MFY=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86aec5d44d71-46aae;
	Thu, 05 Nov 2026 18:41:09 +0800 (CST)
X-RM-TRANSID:2ee86aec5d44d71-46aae
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from utest (unknown[223.108.79.103])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66aec5d3eb20-46190;
	Thu, 05 Nov 2026 18:41:09 +0800 (CST)
X-RM-TRANSID:2ee66aec5d3eb20-46190
From: Shunbo Shi <shishunbo@cmss.chinamobile.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: dsterba@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix delayed_refs_rsv leak when realloc shrinks an extent
Date: Thu,  5 Nov 2026 10:41:00 +0000
Message-ID: <20261105104101.2001-1-shishunbo@cmss.chinamobile.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
References: <20261104082834.25047-1-shishunbo@cmss.chinamobile.com> <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 4 Nov 2026 at 17:41, Filipe Manana wrote:
>
> This last part of the sentence is unintelligible... an opening quote
> without an ending quote, a backslash for no reason, and everything
> after the opening quote doesn't make any sense.

Sorry about that, I will rewrite the whole paragraph in v2 along
the lines you suggested:

    ... updates existing->num_bytes but neither adjusts the space used
    for checksums nor releases excess space from the delayed refs block
    reserve.

> We can't update delayed_ref_csums_deletions blindly without looking
> into existing->total_ref_mod.
> This else branch should be:
>
> else if (new_leaves > old_leaves && existing->total_ref_mod < 0)
>
> And I probably missed something more.
> Sashiko is complaining about that I think and more:
>
> https://sashiko.dev/#/patchset/20261104082834.25047-1-shishunbo%40cmss.chinamobile.com

You were right to be suspicious about the grow branch, and the actual
problem is worse than the missing total_ref_mod check: since the head
reaches its total_ref_mod transition in the same call (realloc with
ref_mod == 1 turns -1 into 0), the release below subtracts the new
size from the rsv immediately, while trans->delayed_ref_csum_deletions
is only folded into the rsv size by btrfs_update_delayed_refs_rsv()
after we return.  The rsv only holds the reservation for the old size
at that point, so its size underflows and the reserved bytes leak (or
reservations of other pending delayed refs get released prematurely),
as Sashiko's report spells out in detail.

So v2 changes the grow direction to take effect immediately as well:
it adds btrfs_delayed_refs_rsv_add(), which grows
delayed_refs_rsv.size before the transition can release the new size,
keeping both directions symmetric with the release.  The outer check
still uses total_ref_mod < 0 (the reservation state before the update
is applied), so the adjustment only runs while the head actually
holds a reservation.

Thanks for the review, v2 follows shortly in this thread.

--
Shunbo Shi


