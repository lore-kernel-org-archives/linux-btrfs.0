Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD9C19D074;
	Thu, 30 Apr 2026 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777561463; cv=none; b=Y48uH7qv4yO9zo/CGnbyuP98V5fnYS1FLEbesdaBAdH0UtdYRna/IIvT1ekTLDrLKs0oi7I5CrmT83DTPHEaGhf57yu1FzXr4wSTHCPH6NXKLx4dvvnz+5huqCBtl1mXoHXK3c2Oa2Y00kbntBJN+/8dFJb/vS4UgRswtiZqL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777561463; c=relaxed/simple;
	bh=DPoNqejj7L+Qi9qzpFKoImHPM8d005RnQS3YCCnbqjM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=I9Z969WtSBS5QtM/M9jOIau/cuPgijvkFu16F8IZsEKI/aMRbEJyAdHnk5tC4qP5ZhYeE7s82T6xRerSjX6laArTR+rvRfGZhGxkMZLkcc1QCNbk+wuMjJ5Gs7cAbIkwAV088eQlOy5dcRWJD+QOcFqCmlYoUOptJK31XpfIHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qB3bjfQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qB3bjfQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F30C2BCB3;
	Thu, 30 Apr 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777561462;
	bh=DPoNqejj7L+Qi9qzpFKoImHPM8d005RnQS3YCCnbqjM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qB3bjfQ03/ociA0V93GPGwkYzdmJ2oXxS3aBuCq3uttB8MlXl9/nCBLKxPuSOayon
	 vCH6Wu3MDdLDNfpfk6pkp2YsXoJPWKYByBXQ99a3w6f6/yx48O04urQTxCBnvZ+0oN
	 6VE5InbibO8ND/EcmXHJ2X/Mwnd0XUKBk9VfhxHo=
Date: Thu, 30 Apr 2026 08:04:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260430080421.902b8e38df2a3b79421396bf@linux-foundation.org>
In-Reply-To: <4C10A739-4931-4922-B2C2-245A610C0120@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
	<20260429152924.727124-2-ziy@nvidia.com>
	<4C10A739-4931-4922-B2C2-245A610C0120@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Apr 2026 10:37:52 -0400 Zi Yan <ziy@nvidia.com> wrote:

>  +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> > +	 *
> > +	 * TODO: once shmem always calls mapping_set_large_folios() on its
> > +	 * mapping, the shmem check can be removed.
> > +	 */
> > +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> 
> sashiko asked:
> Is it possible for userspace to intentionally trigger this warning via
> madvise(MADV_COLLAPSE) on an unsupported read-only file? Although in
> a later commit, modified file_thp_enabled() will prevent this.
> 
> Answer:
> It is possible when CONFIG_READ_ONLY_THP_FOR_FS is enabled, but it is
> unlikely a kernel will be shipped at this exact commit.

Yeah, let's not worry about minor bisection holes.
