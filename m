Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DA229E0FD;
	Fri, 10 Apr 2026 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775835538; cv=none; b=qblxk4fdBFK2JMYW3Ytb3KnmQjfoJSpCZAtC2ZlMb7X3zEyGbLEeEk4tFTMs9PV7CkFJ8LnEBmgDTOMntcYSaWTHhrfnyNriY/DlqTApVxNkGDlnSoI7xkV8LvUkvT2WsuofN3JKh+rFrOcI4PPNVJw2KUC+9fMAXH5gk84WVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775835538; c=relaxed/simple;
	bh=41M8FW015ImHDtpNYPjQ255JZLOq6YFwTBjISfNoNuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=De3arLnme0lbSpO1ODjHfwuyaWnZg3i5oB4dM9WDUlS3rm12OkEoWLLk37uLlsFmwv+lgFB8ThAkASDQpsqLs0exEm6z4ozDeDZeKEDLQqrUt9BivDborBtK98PAXAdlK+DkeDoTHYvG0DCU6ivcqQM1rze8gVHfsEwSzm2y8mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de; spf=pass smtp.mailfrom=anarazel.de; dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b=sNmsjWZT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cLiUg49G; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anarazel.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="sNmsjWZT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cLiUg49G"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B3375140014F;
	Fri, 10 Apr 2026 11:38:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 10 Apr 2026 11:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1775835536; x=1775921936; bh=gJxIaY44SK
	RSuRDHa4BqhYT4Cng9qUO02oLL9GGx6MM=; b=sNmsjWZTZoe2EFh8KAfLkDGFKl
	J3Zgj/EjlNAPNcUFRM6fiDWu66sjB02Yh/m9KvNRXbdPO4glD6TcIFYZKMmcZYlg
	Vnx6I72diINd/P0dD43qG9bdMeCWFuHewUMRIPJ+W5xhdhUhMsBxMnxpuDfv8ewV
	ZNL114gd75F9ocLzzN1Klc70QRbSbBIFxSni+TMeGdbxBqSt1/58qbRi0guySLTE
	MOQ0nSkHxNt+wlzHNP6b0SRTTyfPzhRXB6/lU2Lw3p4fEbUiHDGXeOr+iyW52iIY
	gfZoGWtsazMxN+7g0I37WrUXowRxvPK5c8VmpR3vXzghNlDLz+QNy3rnG4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775835536; x=1775921936; bh=gJxIaY44SKRSuRDHa4BqhYT4Cng9qUO02oL
	L9GGx6MM=; b=cLiUg49GSO/MiajHcJ6h7uvmPgtRgnqe8Q1vKAwq8Ghhep+l7yX
	hV3IxLeNgPynXodaxmsfSAZBs/Kpx2UYTm89MiJYliNi4iYMyYILy1iJ/MWe+xtJ
	fuYJd5onYPJA7e0raKR8o5jCQ4AJEz0/KvB6hTrIhd+5RbrewnBoybX3nbu4eqA8
	2cNglkcVju3DKobEFHANJh//pRwEUVSV9uQMJKzkYX+fBlwGN89p3FSKq5ISLBqZ
	wjRRywuGx0i/4N/YTbgLSKAijblMLyhd8UBNH4kYKstXjVfMuSQaO6ugETKTeIWf
	9UEMwl88L4z0vgpWsuFuNqE/VQV5Z/Q8QhA==
X-ME-Sender: <xms:jxnZaaSEiYbAExxRxGw3hrePqknEN4E1bmOhprB_kiYncLzeb2RZxw>
    <xme:jxnZaao5ToE9OeBpO456Urq9KM4bEOQKP3C3JZQMf5rgkgBizZGJt3523kf7BDbSq
    ph7BKzYTCpCs8TpvxiwIJHQGhqtrpmvSImW30MviNybQ78hppcMxg>
X-ME-Received: <xmr:jxnZaYwp3VjdsIaWCLVHJYkojrC6a9aAYeZ1CyN0aAAmNFqMS_vrRjYzPpbwwlblfBAIaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvleejlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeffffgledvffegtdevlefgtdeggffhvdekgfegteeiveejkeetudelveejhfeu
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnh
    gurhgvshesrghnrghrrgiivghlrdguvgdpnhgspghrtghpthhtohepvdekpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomhdprhgtph
    htthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegtlhhm
    sehfsgdrtghomhdprhgtphhtthhopehsohhnghhlihhusghrrghvihhnghesfhgsrdgtoh
    hmpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeif
    ihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepsggrohhhuhgrsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:jxnZadDWZDmIVxJvKsBItRlQwa1bAspYS_DJ1quHl1LOpWy6KegADw>
    <xmx:jxnZaeKVowQ4YWpymoOU-KNJLQJgIZc3wHBupXIaWZfWnesBw1NMrQ>
    <xmx:jxnZaYGLwXTamTO1ad_rvxoJoHNZWkun1S95zoRQEIwNvO4tP8l2sQ>
    <xmx:jxnZaZE_MMKcu-jSsK7qK07AX_CerSeGhOAKpTk37iG5kJZvQNa2cg>
    <xmx:kBnZaUhNPTInsFB_ZJfxEYnJSm1s98hOfA68RiFjoBL8FHAiz_tHIZtn>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 11:38:55 -0400 (EDT)
Date: Fri, 10 Apr 2026 11:38:54 -0400
From: Andres Freund <andres@anarazel.de>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <iqz3kxnhilg4jyud47mafl46ftytdmyvfc7kentoo234afa3i6@zemg7yixpqeu>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
 <F4DE9305-8D16-4DD5-B988-FBF5C8BB7B57@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F4DE9305-8D16-4DD5-B988-FBF5C8BB7B57@nvidia.com>

Hi,

On 2026-04-10 11:18:24 -0400, Zi Yan wrote:
> On 10 Apr 2026, at 11:06, Andres Freund wrote:
> > On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> >> Replace it with a check on the max folio order of the file's address space
> >> mapping, making sure PMD_ORDER is supported.
> >
> > Question from a user space developer (who learned of this via LWN [1]):
> >
> > Right now MADV_COlLAPSE on file mappings appears to only only work with
> > CONFIG_READ_ONLY_THP_FOR_FS.
> >
> > That's pretty sad, because I see quite consistent gains (~15%) from doing
> > madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
> > CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
> > I think?) in distro kernels, it never quite seemed worth the fiddliness.
> >
> >
> > Do I understand correctly that by replacing the check here (and the
> > predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
> > start working in more situations on typical distro kernels?
> 
> Yes, assuming your file system supports PMD THPs.
> 
> Based on[1], ext4 and xfs have the support, btrfs supports large folio but
> not up to PMD order. I have not checked other FSes supporting large folio[2].

I personally only care about ext4 and xfs, so this is awesome.

Thanks,

Andres
