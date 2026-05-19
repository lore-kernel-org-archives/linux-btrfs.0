Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250E02264B0;
	Tue, 19 May 2026 00:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151545; cv=none; b=AmXJaLHlDSOCKH3ahopyIUp2xqjXdMsfKwVRuUlTdSlI8H3d5S2IehOkfeMPCgIzOBU5Zu3+4L2R0HWN/abmNxMHH4Lg77AL+/5hJhSBov/hO0uvqio76uH9FU0Rm3sFxcWGq73o5ifzw1kOL8bXhtwgKjc1jLHRPd9IOwWLC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151545; c=relaxed/simple;
	bh=ki8yhdn7llRk4g0Kq6LtI5PPviYPxDkGQNJRCkKty0g=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Tbsrh0/QXRHQA8MYEOs5usVzGRmVxxF/QZOH64AJgrpmvdJ7Wx9FFK3BRCRZHH+djVuL0uBIUEYJnPImEXoxOtihdLIetlMarPPPYTlsODBaTbFbQ69ETVsz79Sos5RfsSbG1Pq5cYUq6xGULSHg/gExnOUcCS6Pv9a9ERVA8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EL01RY3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EL01RY3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B7C2BCB7;
	Tue, 19 May 2026 00:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779151544;
	bh=ki8yhdn7llRk4g0Kq6LtI5PPviYPxDkGQNJRCkKty0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EL01RY3PGeBxGh5imSgwpAxABdUA+2lJwWo6MKl4VmmJ+isKIVk6cukTnjduCoAMz
	 qnFiF/oOE8BhagrtdJkkBTyc5ahNVbb+jDFiXloI0WvHQO1S2FntkqSQFXEwI0Exuk
	 IMvtshuNmQ+q2ew9u04tLdC65yNvaMPDaWUOSFZY=
Date: Mon, 18 May 2026 17:45:43 -0700
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
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Luiz Capitulino
 <luizcap@redhat.com>, Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Liam Howlett <liam@infradead.org>, Mark Brown
 <broonie@kernel.org>, Peter Xu <peterx@redhat.com>, Li Wang
 <li.wang@linux.dev>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v6 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Message-Id: <20260518174543.eb80758a66e87631b3a4dd14@linux-foundation.org>
In-Reply-To: <0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
	<20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
	<0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 May 2026 07:39:07 +0800 Zi Yan <ziy@nvidia.com> wrote:

> On 19 May 2026, at 6:21, Andrew Morton wrote:
> 
> > On Sun, 17 May 2026 09:54:02 -0400 Zi Yan <ziy@nvidia.com> wrote:
> >
> >> Hi all,
> >>
> >> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> >> file-backed THPs for FSes with large folio support (the supported orders
> >> need to include PMD_ORDER) by default, including for writable files.
> >
> > Cool.  Sashiko wasn't able to apply this (presumably because of Mike's
> > CI-friendly series).  I take it that the AI review from v5
> > (https://sashiko.dev/#/patchset/20260429152924.727124-1-ziy@nvidia.com)
> > was considered?
> >
> > Also, please check that the below were considered:
> >
> > https://lore.kernel.org/e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org
> > https://lore.kernel.org/22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org
> > https://lore.kernel.org/959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org
> > https://lore.kernel.org/1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com
> >
> > https://lore.kernel.org/20260508074643.55548-1-lance.yang@linux.dev
> > https://lore.kernel.org/b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org
> >
> 
> I addressed all of them, except the second one and I will reply to the
> second one soon.

Great.

> >
> >> is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
> >> "make MM selftests more CI friendly", since "selftests/mm: khugepaged:
> >> use kselftest framework" needs to be updated. I updated it and put it at
> >> the end of this cover letter.
> >
> > Helpful, thanks.  It was a little complicated because your email client
> > messes with whitespace (it always has!), but I figured it out.
> 
> You mean tabs become whitespace? And does all my patches have the whitespace
> issue or the one I put at the bottom? I am trying to figure out the issue.
> BTW, All patches are sent via git send-email using mstmp and
> I copied the bottom one from git format-patch. I wonder which part went
> wrong.

Your regular patches are OK - but when you informally paste a patch
into the message body the tabs turn into whitespace.

You aren't the only one ;)   I usually don't comment...
