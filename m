Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C6B3CFF55
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778158791; cv=none; b=pNO73FjzEZZsEyNbYYZV+kgc1GsZXrlPwBF1rezdlgjJc5PvUg4QK123ISdEIhe7l7zR9otR/+85DJqNyB046cp71VmZxBRJr8hgCa1NDOiB9vqS8tSvrlTMjoE/QNVmvOtOTyJkRnUpxkCKBmeiFw4tIQMLoqRbXHgLnEu9IMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778158791; c=relaxed/simple;
	bh=N+8on1rJhIM7gFzPDRKP1K79fhr5fu80l2DgfLVZ7Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/pA0Per91lFv5voEiJUMEB40S5sJNo7iRCEJoYDxLXYJjes9y0Jt71tf/Y8dHsvjEChbCVn7fIbLmDO4Hvz0ZUPXVv8XeAPw4MfyEgN6uaay4ZrNs/VxS9Zu1x22adaB77dRzxeOTNcL0VRoKJz94ti8j/wmPUvcPYjYT7Hoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rq2dqH3L; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rq2dqH3L"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778158777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N+8on1rJhIM7gFzPDRKP1K79fhr5fu80l2DgfLVZ7Hc=;
	b=rq2dqH3LbsTDkNm64j4yfugrxYnuo1K5QSVNxsj0wf0x+gTd830yL//sZ1zls/YfFle5Ea
	rHimXqQZl2XdEdZH/pVmBJ7KEOCjfln0xEgi5Y+CUNGbqvdO6qsze8DrzkZ4nbLBf6umJN
	4C9u2RSxqusKL26SGb9MF9QMwi4Tu3I=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 06/14] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Thu,  7 May 2026 20:59:21 +0800
Message-Id: <20260507125921.6325-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-2-ziy@nvidia.com>
References: <20260429153538.727855-2-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Wed, Apr 29, 2026 at 11:35:29AM -0400, Zi Yan wrote:
>They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
>large folio support, so that read-only THPs created in these FSes are not
>seen by the FSes when the underlying fd becomes writable. Now read-only PMD
>THPs only appear in a FS with large folio support and the supported orders
>include PMD_ORDER.
>
>READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
>smp_mb() to prevent writes to a read-only THP and collapsing writable
>folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
>smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
>do_dentry_open() first increases inode->i_writecount, then a full memory
>fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
>
>Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
>since a dirty folio check has been added after try_to_unmap() in
>collapse_file() to prevent dirty folios from being collapsed as clean.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---

Nice cleanup! The old counter/barrier trick is no longer needed;
collapse_file() now checks the thing we actually care about ;)

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>
