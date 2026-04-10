Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049A43CCFA0;
	Fri, 10 Apr 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833589; cv=none; b=MhV9BILZPG+B3Fr/8LxgpQqVt9muJ7IpEhakJdNOaijz0v63jEXSUnmZVRXVZD4zm0JXUjJBA78Df2HkTNc8FHhof/B8KHY9CEv531+AvzXopBfrAIwl8tPTR0+SRKDZH9W1Jyi6Q9H9jCoo5FppG+cTp3f5u1dc+3ElSSAAj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833589; c=relaxed/simple;
	bh=LpyUHvU1hTCEQ3cZoqru+GKoLGkoUTmKSCfIUnf+UMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrqxJ2n5scf1J21XNVFQMhhA5ODg8zTG6LVlHAPEDRHtnR+vg1fz3fdF5ESt/VXMGkwWY+zcpHcXPMMSQC1EvDgBPuTPWEiCUkK65SqhuGpyRYpcRYD7FKb1EaL9AA+bkxFEAnmwDjVIVL5T5PAHSvvUEc1rE6W+083mw8yT4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de; spf=pass smtp.mailfrom=anarazel.de; dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b=bePCmxT/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KYDpbxLf; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=anarazel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anarazel.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="bePCmxT/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KYDpbxLf"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2472E1400016;
	Fri, 10 Apr 2026 11:06:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 10 Apr 2026 11:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1775833586; x=1775919986; bh=akpLVJx0Uz
	SKDAGrU14pFNxh9AN2Pzvbw74VPbTkYmA=; b=bePCmxT/N/H1MhH+hoi/0R1h64
	bi/HFepnAJ8DY7KUS7nx6tbqAanucsJpWG51m4ZZMonKrO7fjQUhF6CMhQ9ArmNG
	Vf561iWQQ2nyMS1SupWgkyDE8FCzMUp+5Y6rcO/okkeLkOSjJs9M02w8n7Orp4i9
	5umoa+CdKQ/m0LQ/LDmlxwDh+tgdtJwfxItAaXqcOs8q2KAPpELM8QybsCo0Wr9T
	OSZB/7DE/m7+B9fukaPVuBrwxsQrjtbyvR8j6qJ9JBsqH2kBEu3PZptPTlK9EgJY
	AfmYUTytxmW0u6I5ujGqBi0MDy05Xs7hv5GhVnKHF8iK3gKAsks1m/QfJEHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775833586; x=1775919986; bh=akpLVJx0UzSKDAGrU14pFNxh9AN2Pzvbw74
	VPbTkYmA=; b=KYDpbxLfgZUnUnR8sD8FmPQqZQWBYKGiZyQ4Nuu3gDm7yVKa1l5
	oU9BaLd4aACROIPfKsoPZL31Q7VAbLxy+LhDEhd7POtcetSdH6GWJ3jnbFice32S
	xAsnSd8gvdarUEugjLJiUEor55xB8ubl9V0eNmfKNOfgtHHTMo5sXg6lhIJtZEuI
	IjJEsSYvwuBUM6YGjYJWdKjERJ5zOzH1J/q5sjmA03KZh7bRqyC++jJ7F2zkTDcM
	Kf3g05ClJB5dtqLdRE2PJFId3tvjbhH/++ZVGZC602b3FrHZvi1fPEpSdGFi7cAj
	/Wlo3NXTh7Fn73CPcjEbXd6mQuhgrWEL1LA==
X-ME-Sender: <xms:8BHZaRZWE8uB9sk4nw4WSr0cLxO_Gpq4yxFWU6nwLNmLb-XpgwWTpA>
    <xme:8BHZaSDvJsNv1Mp_JMHCOdkHdw4tHgAgG0vRZ0uf-UkPzxHFiMVhDgnTKmBW_ECsL
    Epjwd4LUSvc9v4KYMVvij31eZ28wQsFzmWPvJxuoqCcFdnWix48>
X-ME-Received: <xmr:8BHZaXb4T3CkRMSfjd0GOsjZ7KfNW_jYC-iXml0IwW0jt9tTwN7lqNMM_nvRBU2bIJ0FZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvleejfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeliedukefgveejhfetfeetudfgfefffefhgeduvdevheeuvedtffffkedtgeet
    heenucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvgdpnhgs
    pghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeguvghvrd
    hjrghinhesrghrmhdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghr
    mhdrtghomhdprhgtphhtthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopehsohhngh
    hlihhusghrrghvihhnghesfhgsrdgtohhmpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepsggrohhhuhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgr
    uhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:8BHZaWiuFnrmiJcbgqjYx5Jwx6KiLsnEF2RDyhYx8REuoUmPxSunwg>
    <xmx:8BHZaXwQEE8sskDChz9Knu-eb79O2kNvt1AK3OTXxRsWkQWdVO8TCA>
    <xmx:8BHZaR6s62boMLuTfm4hSrccj3m6eYSoy_LU0-Cuscuw2Wx51E2nEA>
    <xmx:8BHZaQ3rvJguxSGxERwmQDm6d80va9z6fdjrC4qbBdoUnkIzBgiYag>
    <xmx:8hHZaaSV_t6dZlVVenZsQ2wO0diHoh5qQ_aF_h6mYSl5lDZXgxgfQfur>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 11:06:24 -0400 (EDT)
Date: Fri, 10 Apr 2026 11:06:23 -0400
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
Message-ID: <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-6-ziy@nvidia.com>

Hi,

On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.

Question from a user space developer (who learned of this via LWN [1]):

Right now MADV_COlLAPSE on file mappings appears to only only work with
CONFIG_READ_ONLY_THP_FOR_FS.

That's pretty sad, because I see quite consistent gains (~15%) from doing
madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
I think?) in distro kernels, it never quite seemed worth the fiddliness.


Do I understand correctly that by replacing the check here (and the
predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
start working in more situations on typical distro kernels?

Greetings,

Andres

[1]  https://lwn.net/SubscriberLink/1066582/b92de1d7595a01e4/
