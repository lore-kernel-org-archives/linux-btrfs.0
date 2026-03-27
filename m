Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F02330644;
	Fri, 27 Mar 2026 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774628095; cv=none; b=JtYqxJ5bqfqWS2ZDl0ZH7coTP54qMBnBvEnRZOMAqFRAVALQ77EIl1G9p00IcQ04VrqeI4iW0NlAcdF649ABImzz956slRw6XX/H0SGK3sbwEUaCxTMHoFTq65yiM/kvIWbJk6g8L87RLsI9m2BpLhA1cscBogmRLWEST3qhyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774628095; c=relaxed/simple;
	bh=zXNUom4JcbcJe5P17bW0VcYg3BF2y3vbuxuAyWXA2Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlHku/hBh5CiudsF+u3fS+xh6tvyZxDs2Wkk+/lYcb3DKL5MWzIrsW/GCMkfbN4JiFI7e2vqg00gvjC8YHsHTRi0PJmvk1NhwCCwiCN///s1cianYPFuWcT0GxoaPy1VGA+Nkc5ERPrR5qudNVvjWqhXyoHodZNfKOb+4swq0ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYqHZHqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYqHZHqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C0FC2BCB0;
	Fri, 27 Mar 2026 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774628095;
	bh=zXNUom4JcbcJe5P17bW0VcYg3BF2y3vbuxuAyWXA2Yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZYqHZHqoR6y2KHbwdL3I4ZDGCUvKQVvkCNilvo9VFfK+sdEwwTjvdXUng8CkB7/R0
	 y2A0V03w7X6WjHqqd/kgfuhGJBSA3J/q3PjhoVwq2zkB98Ka8b6A5oXju/bsSPygDJ
	 PKUxVg2T7fMjcYFKT6FpqBH5sNByY0nEl3Z5ay7vWhaILcHJEXiefoudbSUOHxvR3A
	 T0ovJe0NHcSU3WmsVuhpWMI9QpGMOnSw7wFCAKv87aJ4oQX4wzMlN60Bslfs6nVHHC
	 DqLMrUA6eTo1ei9iwueDiBgHjCJE9VKB30Fz4xqvTB8jm0kztjIvo6g8oQxdV5olSM
	 t6qw8eZhk8WPg==
Date: Fri, 27 Mar 2026 16:14:47 +0000
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
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <be4edc58-d343-4db1-b861-31c98089b3dd@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
 <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
 <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
 <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>

On Fri, Mar 27, 2026 at 12:12:04PM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 12:08, Lorenzo Stoakes (Oracle) wrote:
> > So actually:
> >
> >                        |    PF     | MADV_COLLAPSE | khugepaged |
> > 		       |-----------|---------------|------------|
> >  large folio fs        |     ✓     |       x       |      x     |
> >  READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
> >  both!                 |     ✓     |       ✓       |      ✓     |
> >
> > (Where it's impllied it's a read-only mapping obviously for the later two
> > cases.)
> >
> > Now without READ_ONLY_THP_FOR_FS you're going to:
> >
> >                        |    PF     | MADV_COLLAPSE | khugepaged |
> > 		       |-----------|---------------|------------|
> >  large folio fs        |     ✓     |       x       |      x     |
> >  large folio + r/o     |     ✓     |       ✓       |      ✓     |
> >
> > And intentionally leaving behind the 'not large folio fs, r/o' case because
> > those file systems need to implement large folio support.
> >
> > I guess we'll regress those users but we don't care?
>
> Yes. This also motivates FSes without large folio support to add large folio
> support instead of relying on READ_ONLY_THP_FOR_FS hack.

Ack that's something I can back :)

>
> >
> > I do think all this needs to be spelled out in the commit message though as it's
> > subtle.
> >
> > Turns out this PitA config option is going to kick and scream a bit first before
> > it goes...
>
> Sure. I will shameless steal your tables. Thank you for the contribution. ;)
>

Haha good I love to spread ASCII art :)

Cheers, Lorenzo
