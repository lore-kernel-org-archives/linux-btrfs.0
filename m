Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39452E040D;
	Sat, 25 Apr 2026 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154775; cv=none; b=jBjYRpEECjpPbMQVW/T56QQaZsI/ktXSyqawOeWBg4mWTO2adPhrA6pfhRa8x/DMjC9bHvzJM5F7u3E1OLUQQ+HHwf202GzZByLXBCKHZ7q/urYfl8Y+DZYf4R/D2ByrvWieytvsmdmOSrw5dLD/yHiYPQjd7hfFSkR/7oQzBXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154775; c=relaxed/simple;
	bh=JmdZeHb+QkjT2bTecCzSWXS+NDAQS1axJxUikbfjX5E=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WX65RMqmTddJcz6gPq7tFCLBqVyQJdP4W3ZlHj9vwvVMNUbIB0kB5AqCmJaKqNHW2vwchlgQwJ9KfZ23DKgxjUjrNXHur0XZcMfiKf2+O2VOVrDGvfPwBtMP4aT/FAanMYtEszAgTF0QQcmbHdE5Pp7X7VfKxS8m9/jWcSkc5Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X71ZYRkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X71ZYRkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD45C2BCB0;
	Sat, 25 Apr 2026 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154774;
	bh=JmdZeHb+QkjT2bTecCzSWXS+NDAQS1axJxUikbfjX5E=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=X71ZYRkUooK2QqiiRZwySFYsaMow+deyEDAryCidXeWa9PgkyvUgzYm9S5ErazUw9
	 gcQE6cyLQZMkLso7SUwEcmR6LXogQmN9e0CHQI30/Dj7c0kd4TYfvwGmqN3ehQPzjn
	 HvFw87ovDcooQiHikqH74uAiHUsXwdssPwhYk8c4=
Date: Sat, 25 Apr 2026 15:06:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260425150613.95532603a9a9404c7638f65c@linux-foundation.org>
In-Reply-To: <20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
	<20260424024915.28758-2-ziy@nvidia.com>
	<20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Apr 2026 15:01:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I added the below.

Nope, still doesn't work.  I guess 32-bit arm doesn't have a PMD_SHIFT.

The series has a few todo notes:

https://lore.kernel.org/f416ea70-fb70-434f-8807-6638c9787b57@kernel.org
https://sashiko.dev/#/patchset/20260413192030.3275825-1-ziy%40nvidia.com
https://lore.kernel.org/DDB6CEDD-116D-48C1-B558-D64CA2F58F55@nvidia.com
https://lore.kernel.org/896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org

so I'll drop this version.
