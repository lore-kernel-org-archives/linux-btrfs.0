Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1011C5D44
	for <linux-btrfs@vger.kernel.org>; Sat,  2 May 2026 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777716719; cv=none; b=OSCUCB+K6abzgVl/rYf3EyTsEi140x0raHj3yoVqP/dGeoybQUwdLAOxFW8IVMBjBzta1BLIBdGEdW1vfM4eDeEwxXQt06A2wcBN8xlIiYBNwpO0VyDEJ7oLVv0xntloV8YCcGqLget55Yel+dazLTf9W5VMwpDUuj8YnQP/RXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777716719; c=relaxed/simple;
	bh=Ab+u6dSSVai8Uvf/LRtOvY8KpmBvhT9ICp0Td9Z3Lk8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WbmgPZoya7DTiQ7ejskt9pPpT96R9f82Wf4DjjWxbi65OwKxlKb4JeH7dg8lve70W8qO20PSA5wAShEz75Wqsos90XFLvsktSW0jyi/snwFs5wCIAHsAMBwinZzgxoYZ8T0NeNf3/h/aJ85uWy5DM05/IBcqWGizQQa6+HdJ+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca; spf=pass smtp.mailfrom=maxchernoff.ca; dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b=nvFOyZRS; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxchernoff.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxchernoff.ca header.i=@maxchernoff.ca header.b="nvFOyZRS"
Message-ID: <e3a5fe230cb90d08acd6b0d99dc3477cfe7a2314.camel@maxchernoff.ca>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxchernoff.ca;
	s=key1; t=1777716713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3JR7/MwQqqOmRM+k6QrgsSjpsPjSmPHlN5uPSuU+nQk=;
	b=nvFOyZRSrLvWLi37KtiVV1LM9gQOgijYWAQhu5ApfKpbeS73kd3rPfot0v8vQqPu55D19n
	eWbPQVyDBusD5kq9EB4IokkZlFih+pXZCwX1EKweLJZ3LAuoaIH5sUcBeUu2AMPHXKNF7v
	gV7YGKK1PYWnMdnBxM4+c9ofpecmFW55KMqIj4c9Owlpwplivl8tDf1LNl6AR8BLZJTMGS
	6wuB2ZdFIPtRZAq0hzKixt8ELbBETdHMMCCEno+K2ATSfYINkFDG5xzZLF0Ml9YfBhAb7G
	z8f+Irie6eL9ToDgcg3yliGGgoELBfwFfk/4Sag+xmryVk6aoPy/9AN2m037OQ==
Subject: Re: [PATCH] btrfs-progs: docs: update the qgroup performance hit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Max Chernoff <git@maxchernoff.ca>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>, 
	linux-btrfs@vger.kernel.org
Date: Sat, 02 May 2026 04:11:43 -0600
In-Reply-To: <2da00f33-9325-4bd8-b874-37b0ef204f7f@gmx.com>
References: 
	<313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
	 <5b2ff34a3dabf213c2a0058578ab73cafe36b16d.camel@maxchernoff.ca>
	 <2da00f33-9325-4bd8-b874-37b0ef204f7f@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT

Hi Qu,

On Sat, 2026-05-02 at 19:00 +0930, Qu Wenruo wrote:
> =E5=9C=A8 2026/5/2 17:06, Max Chernoff =E5=86=99=E9=81=93:
> > Would it maybe be worth adding something like the following?
> >
> >      If quota support is absolutely required for a filesystem with many
> >      snapshots, then "simple quotas" (``squota``) should be preferred
> >      over "quota groups" (``qgroups``).
> >
> > I've never used simple quotas myself, so I have no idea if that is
> > actually true, but the documentation suggests that that's the case at
> > least.
>
> Squota has one special quirk that makes it pretty anti-instinctual, thus
> I intentionally skipped that recommendation.
>
> E.g. We have subvolume 256, which is the initial subvolume, have around
> 128MiB data. Then a snapshot of subvol 256 is created, that snapshot has
> the subvolid 257.
>
> Now we have something like: (squota has no distinguish between reference
> and exclusive, it treat them all as semi-exclusive)
>
>    Subvolid         Reference/Exclusive
>         256         128MiB
>         257         0
>
> Here we ignore metadata to make it easier to explain.
>
> If you know subvol 257 is a snapshot of 256, it makes sense since there
> is no new data in subvol 257 yet.
>
> Then if subvol 256 is deleted, things go ugly immediately, after subvol
> 256 fully deleted, the result is:
>
>    Subvolid         Reference/Exclusive
>         256         128MiB
>         257         0
>
> Nothing changed.
>
> I do not believe most end users expect results like this at all.

Ok yeah, I agree that that would probably be too confusing to recommend
to unsuspecting users. Thanks again for the explanation.

-- Max
