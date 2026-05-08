Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A6A309DB1;
	Fri,  8 May 2026 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778266445; cv=none; b=NZfsGXLyKBvkIjxC6arUiLPiIC6YMrnO8cfnl9VjjXkq8zOKuy5NZeA1tsuYPEf0/WsnKLNt4wRejMrirNw61unj2EsxRoMMmB/D8NwPRTQRnMj7kKnlf+53UES8wBdSfWGea3+ov47dLf+tTIvEMNW6SOYNdHLONoU0KFxGWZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778266445; c=relaxed/simple;
	bh=u+07b7aUwarNJTFfKewd4gBl4RTENQ6to3G5ZCB7kMU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LzdCR4J4YrhfGvRR0yNTE6PWtFmWV4l/KUjdgBOINiWCz9yi03X83iX6D2Y5Xg3mbdb3LVeGjoHkL6tbtOWUELrHwvdKYUD2y5O2asehrM/111oA5OrPlOIuCbdCIIaniISXeRPnZHAZD3Xb3+WZxPhQ84n5aJmbMWpxtVrIqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMuolbXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMuolbXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C4DC2BCB0;
	Fri,  8 May 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778266444;
	bh=u+07b7aUwarNJTFfKewd4gBl4RTENQ6to3G5ZCB7kMU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IMuolbXz4+dg7D5Mak8WRFZ0ksIuPYXXu0O5916t3mbFVA5Hp+lLIu9FjOc5dU5XF
	 F1atK9xvJUlRloUcCy2fNA29eOT85Iu993IzAvVX46tYs40idz1IIs9v4oMHEDcTqt
	 V1AW9vaxpyr5mogAo4cLX472i9TE8UvC1/euYolI=
Date: Fri, 8 May 2026 11:54:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, david@kernel.org, willy@infradead.org,
 songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_enabled()
Message-Id: <20260508115403.055ea15a6852bacf864b7ad8@linux-foundation.org>
In-Reply-To: <20260507044938.12529-1-lance.yang@linux.dev>
References: <20260429152924.727124-5-ziy@nvidia.com>
	<20260507044938.12529-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 May 2026 12:49:38 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> I just noticed that mm-new commit 83f151d1f7e3[1] links to this patch:
> 
> Link: https://lore.kernel.org/20260429152924.727124-5-ziy@nvidia.com
> 
> but the applied commit only has the include/linux/shmem_fs.h hunk ...
> The mm/khugepaged.c hunk seems missing.

Thanks, fixed.

> Was this dropped unintentionally?

Nope.  Collateral damage when I was trying to figure out how to drop
"khugepaged: mTHP support, v16".

