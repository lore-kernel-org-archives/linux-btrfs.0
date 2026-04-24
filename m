Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A89A3191CE;
	Fri, 24 Apr 2026 10:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777026645; cv=none; b=mHSeZVoiij+BZKJjBzK1mr4/iKrEGaOU1Stqvx42yhr4pRMBguD4IYLSHeuaLHBWXXcmW5tgcMR6RVrksLvxK3S13k5WlkTn6YVWSd4TUjzZdsd006Wza3cdEYxMiiDNklSq0ywcwgg/EEx+rHpxYA4XAITI2ZdeOUxNTaEL1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777026645; c=relaxed/simple;
	bh=4xYRFTsa+snUwsnsMlD+flP8XlsjYGjzwbUWIong2Ao=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BzYN3z+e2sn78i+Fbu5XTHH0jBuECx2h38zb72skBTQWEjDgAjbpNRmIzBJl6Aq5kBtyrd+t68GeeJEAcUCIa/wGm8WT81L88EikGy8lzVHtkvmFITQ/Esq/IJD04qFxtkcoWrvzKIxvdhHxkOxX7mgnYbjTYLzq6AMASKKQ7Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gQOY41Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gQOY41Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D67C19425;
	Fri, 24 Apr 2026 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777026645;
	bh=4xYRFTsa+snUwsnsMlD+flP8XlsjYGjzwbUWIong2Ao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gQOY41JzUhrlE5H3970ccwjTNwmN96kWmFFRqnM/fHwgXOe7doEV0seAfQ6jigNCP
	 ozUA2T42qL9kFIgNzPFYogwDvXy3/+TjJhF5wet0aF+1PW50r7Mwm/r+y5jrFMOOSP
	 mKaQKAnxeW96a3B6qlgvePIfLIqJ9uYZHXO+IczU=
Date: Fri, 24 Apr 2026 03:30:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu
 <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 00/12] Remove read-only THP support for FSes
 without large folio support
Message-Id: <20260424033044.440cdbb6ee872f9a815c841a@linux-foundation.org>
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Apr 2026 22:49:03 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default. It is on top of mm-new.

Thanks, I'll add this for testing.

4 of 12 aren't yet reviewed, but that's what we have akpm nagmails for ;)
