Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7D3374A19
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 05:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789363753; cv=none; b=l9/KHb7Xp3E861y1l5bZG22FD7541A6BYds0PlEjd6xtAFXr0HxR7yNA3s9rkeQykYELMLjQyfaiib0WcJ4ooAmjnI0ew8bgTzEZGHynC4OsieFWJbNJsiyDMvrfCAt0qNIEm+o5QfPSsJOKJKN1Wg0pnP7hpFfDEzcGs0E/v8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789363753; c=relaxed/simple;
	bh=AHJ/2TPMez0GKOpjhRk9cFO5vyZQjAlROJacpdChtb4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Eo6bhdH3OjEY3H395jHi0MjUQJAzSS76g1sjA9NRWozNJHgCQpeDdQtV0XGYiadglu2yT3bq6+bxWnC7bbMHNmW5pWBhTOcdW0JIjQv4YcrDOHuU6/oxdOFsCRRtLbyMosX1bKuDSWVp1GIiO4aS9UlSp41Jm2S5mbF0DRIqxNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A1bvQ7Rw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A1bvQ7Rw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AHJ/2TPMez0GKOpjhRk9cFO5vyZQjAlROJacpdChtb4=; b=A1bvQ7RwQsSVIm7Vr7xES8bSDI
	NNrvl8FUeRHElh6TLxMJGt9TVkoBRoVrBqwaJ9CwSyvMIySvm/+WdK+TGvSFnO72GglfbA2a/ns4B
	/2/ivQFAVXcH+11ExKx9v2TGcDFW1HXJmfkzV50A45p6nOEDdvqy0NYyl0MgHgyNh8bHIIXnNc2/1
	jQdy0RO7m27nUUvw1uHhTFseMQnt5AEzuZZncMGcZj+TiPgEEIG+asPVYFG3lOK3kbroUsqhecNYt
	xcNfoU6ROtkP+YNgtlcBx6ta/fVZ0ScKsetCAEtdz+gGA+L4O6tYMSOm7EeMyD/kI4MmoA3fLqU5s
	rtyfZFSg==;
Received: from [2a00:23ee:1508:2c6:b3cf:d335:d64:51cc] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x5zFT-00000005Gwn-2SK0;
	Mon, 14 Sep 2026 05:29:00 +0000
Date: Mon, 14 Sep 2026 06:28:58 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Anand Suveer Jain <asj@kernel.org>, dsterba@suse.cz,
 linux-btrfs@vger.kernel.org
CC: thiago.macieira@intel.com, dave.hansen@intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_btrfs=3A_derive_f=5Ffsid_wit?=
 =?US-ASCII?Q?h_dev=5Ft_only_when_temp=5Ffsid_is_active?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
References: <16069a6fc651168bfcd2394d6e57ce63a50231ed.1789235482.git.asj@kernel.org> <0691a903-cc82-4ad7-8264-cddbf146d00e@kernel.org>
Message-ID: <91E0EA5B-BFD2-4B8A-8408-4F561D5E0777@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 14 September 2026 04:42:51 BST, Anand Suveer Jain <asj@kernel=2Eorg> wro=
te:
>
>
>This issue and its current fix (below) have been on my mind, as I wasn't
>fully satisfied with the approach even though it works=2E
>
>Now, I think I have a better idea=2E
>
>The core issue isn't that the new f_fsid derivation is wrong (recap:
>f_fsid derivation changed from f(UUID) to f(UUID + dev_t))=2E Rather, the
>problem is that f_fsid changes unexpectedly after an upgrade=2E
>
>So we need to address the upgrade behavior, not how f_fsid itself is
>derived=2E
>
>My new proposed solution:
>
> =2E Put the new f_fsid derivation behind a compile-time config flag (an
>incompat/opt-in flag)=2E
> =2E For stable kernels, this flag will keep the new f_fsid derivation
>disabled by default=2E

No=2E That still gives you a broken fsid on upgrading to the next major ke=
rnel, doesn't it? Maybe a new flag on the file system itself to indicate th=
at its stable FSID is computed using the new scheme=2E
