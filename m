Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE5F3FFAB6;
	Wed, 29 Apr 2026 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777479188; cv=none; b=Tp9hDMsDPef4tBVQvQol18YaQmG/DOdGgjW/zOtW2lv7I3H5mwkFz/B+utBriLfLunUKOFne7G4yIGLlsw8W6Ia3vJdB2BZqrPF6hmhhvteSzTEsZFPdJY0eLY6XO/baPMoUiRlbSA9aNfkZ6pXCB4zeIwqwebNgVF3w02S2krw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777479188; c=relaxed/simple;
	bh=+vFVN7Kin1nhN2r5SBUVavKKjBx5pzFJOmavyYzOZmY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kg0jYR5b4HoUqUMDwsqFegeqkP2duoM1dBbyzmH3ZnmPte3J6Cb4GsaV0E9W0iod9OlG+S0Z5UxWMYCFltkip5icMzxc9NdOD3QIFEXsu7lwHPiJ98p5MctHRtWFgp8pKovcER8kkQW7zASJK/8RKvUAqLDJwdkwOnomdKdQosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jcA92KrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jcA92KrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDC9C2BCB8;
	Wed, 29 Apr 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777479187;
	bh=+vFVN7Kin1nhN2r5SBUVavKKjBx5pzFJOmavyYzOZmY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jcA92KrTNs0OnsDplxqE80x6fHHXTL7QPJhx1p+U/TsX90ivdKhWaMnApqeWn5VnM
	 uywt8NYVjxKNJk0sbEz6e261uEkqKwumAVA1mP64nBSK2PczEqjvnA5Z4RMJgea8Mf
	 lmQxnXMi3PXiEOAxLXppMhDws0pje8NY59geYpow=
Date: Wed, 29 Apr 2026 09:13:05 -0700
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
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Message-Id: <20260429091305.fd5a1c8c986c111527c2b024@linux-foundation.org>
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Apr 2026 11:29:10 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> file-backed THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default, including for writable files.

Thanks, I queued this up.
