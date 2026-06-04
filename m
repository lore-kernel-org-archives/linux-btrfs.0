Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E92DECCC;
	Thu,  4 Jun 2026 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780566770; cv=none; b=N4WnjKXbNtKPUEy/gCZHOytLtayYVjWjyda9JEPii71BM9gsUgwh6fM9wBWujhovVngXJUhOm7X21XWp0Yr9Md7jRckMm+0CD3OP9ow6EZLC5dUvM4Ehkga4tJA3x7/TOAfeCCzoQVeywjO3qSxmCmhX1/qyjpSIECPDdy8eFWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780566770; c=relaxed/simple;
	bh=gg3R/utfQnEsUrwuRKVQ4KuqFbw3VZz2Nfu3CCurB4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNrpKwfDJVQSEvCCmjUBPJaxw5hkMsd/Y8VL63URDYKZyKvq4IbnuqP5Bbx4nY2G3ebvwATBO+G74LRaELE4jtrG6/hd3FDXRTItybGiOjtft3Xb3NVXY+9eqlHPtDTPgROAR4d6IU8fyB6Iq17Jm0801OBJuCi1z4rehfTNXY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Cj7XKzxy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Cj7XKzxy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xTL3V3QwkCYsZa3XibgZ6/fXpHwDDRnG2fWwtkgdRac=; b=Cj7XKzxySP9FkYEvBb2z07Jm8A
	cArhiUalcMuPUp7eEC1W9vqx+u8NubszXdeCoW4hm2vSNk2tVj3BCAYUprJ+uwtSIhui3IQLU03xx
	C83R378ShK9bt3EEQaPLFodpgwtAEnPQsDFZ9A8C6HEk3Kfujnsk6/Op6sn6THgMYpvncp/BSTBU2
	TLz4kHBMz75YubWJz5e3OflywviQwcqupsnrkTzYPDzBsDhwmisSWOuS47MU4GuOoj72J34N4WzMK
	1cIo2+byejCQb5pJDxTWh4+P9cpk9YN+j8QYemtjVx7Us5eHpyQ4EynzyMA9/TvunMLnAeVoILvUT
	9j9c2dDw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wV4kk-004QoM-1L;
	Thu, 04 Jun 2026 09:52:42 +0000
Date: Thu, 4 Jun 2026 02:52:38 -0700
From: Breno Leitao <leitao@debian.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Marco Crivellari <marco.crivellari@suse.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Message-ID: <aiFKsSlaq-_VBGtZ@gmail.com>
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
X-Debian-User: leitao

On Mon, Jun 01, 2026 at 07:46:26PM -0700, Nathan Chancellor wrote:
> After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
> WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
> btrfs-qgroup-rescan workqueue at run time:
> 
>   workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.
> 
> WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
> WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
> alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.
> 
> Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
> that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.
> 
> Fixes: 69635d7f4b34 ("fs: WQ_PERCPU added to alloc_workqueue users")
> Fixes: 21c05ca88a54 ("workqueue: Add warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>

This will solve the following issue I am seeing in linux-next:

   workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.
