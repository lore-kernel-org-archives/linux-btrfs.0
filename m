Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185953F660B;
	Fri, 27 Mar 2026 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620968; cv=none; b=ZQAOv98w8I5jU9g99alispRgkTzgtTMRlubmjSpOK7pr+YzTgYNq6gspgO9PeOY0aU674gbffEifpBuzHdIrrmxEb7vNrhLsXRa/D13dIoINAWCyzgrg0VGsr87U3LXN0Nygewhlwdc6ra3MrFW04w5Z3d6k0rDwM42wBrJLDi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620968; c=relaxed/simple;
	bh=cth6dxxe3aanFcyw5202phYvX47q1y5QBdQQTr+zt60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyviQ1TFyRcO+UJh46HmrktrQmFHVLSSIgTG/LprVa7OCKz+ZQr9VJZmnCgY5i5LJYXFRP6/L7NP66cFkwc+eO8C+xNYsPTib0V4I1/JCg/ZH3iB4htNoSIjM+KUE0uutLddHLe6fayKiNv30whFqMfFf9VsR1J0JctxEjXUk8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWG5gky0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWG5gky0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D6C19423;
	Fri, 27 Mar 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620967;
	bh=cth6dxxe3aanFcyw5202phYvX47q1y5QBdQQTr+zt60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NWG5gky0F9g85HFcO+1A//0rEzZc653ybEusycz7wMImYbsVsFcPdrmOIErCla/rf
	 ghRjG9HM6qdzEvTR1fr/I2HfTHlP56UmFPjs81tCGP7HTKwzNINWgql4XeP4vxLMRX
	 ndOsWYJzmmkF33kXKMMOgdIczrsZT1dbP+/z7lzIUVoOTL1Hl28nW+99olIEf3/iU7
	 TuFq5hbtduFU5wLCr7qTUwB3kyDoXGMpL8MKkKT/1Dg4xoXz6EsC1lT0WmolXapBWu
	 diqC+zh9otnP5sw8OS1/QTgNFmOaQi084gPmjeel071Tu6D2jmZUBPaIHtIrcf/GSB
	 kSkbgZDcSjB4Q==
Date: Fri, 27 Mar 2026 14:15:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <83506fe3-3b38-4053-9173-bccd46b4a297@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>

On Fri, Mar 27, 2026 at 12:07:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > +		return SCAN_FAIL;
>
> As per rest of thread, this looks correct.

Actually, no :)
