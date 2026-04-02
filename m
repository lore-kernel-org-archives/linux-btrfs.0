Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523D364949
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 18:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155952; cv=none; b=bqDaW+GPYMHgm/gkqpPFpV22W7/u+Cl0tHuLqeES55BwovSafebSJnRPfgtdRRekHmZHAiY5ZfOVha5banMZhagDu2VGtn4K5e0gtvOq+YeEcxaePedxKCka+sQ3WOHYsvROqQj0nRoHGImJ5JNtG8hVXmHhOczPjQlP1gnkpDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155952; c=relaxed/simple;
	bh=IjH+bZF470UTwpeG0EhYkcJNU7zR16t8m161WhiVDA0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iHcvTjKCBnvlxR5dhrz7b/02hPHV1eotCQxqa9eTturlHYWKARwpbfVClSgFUOdRRfIx72SymtOEGOrPkfkTTYPo8C3kVdFdx5NFFzBSjvqk4vyM9DyX6ezwyUIj9/IaK5mUBtQzwmx4thHUDnQfRJNpEE/iYKua36rD71g14qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxLBJRvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxLBJRvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4724EC116C6;
	Thu,  2 Apr 2026 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775155952;
	bh=IjH+bZF470UTwpeG0EhYkcJNU7zR16t8m161WhiVDA0=;
	h=Subject:From:To:Date:In-Reply-To:References:From;
	b=IxLBJRvpUXFCu9MsWWwAbAmAMUNwkCVvQ/1ZPb/UgqIlJvs98BvUDPeCP3gitJGEF
	 r2TLr+7a9vQnstxAtEppsApPs79sQMAL3cP4cEylvQfVsKt1nsxpa1EtxEz1yH1uqx
	 b6DF6NRhVWRzukteAs0DzRrknPyK+59oSCvnVElyy48t/C5ctQTshLpx3PqTK7HLIQ
	 wXCAcOddiYeOe6XvifJpqHJLqeTsapAfYpdNCyi/gQtGys62iikzBxFRA01wlSJHQZ
	 UzPII1PIjeXKcPV8nE/Rpn4L5Ube1yXWSOgpWqg/eEoKR4zwU5R2VhXno4EKypKbCJ
	 hkEwG4iktYXkQ==
Message-ID: <e641e0aa7dba28cabbc3f889e7caeb7c1b857f35.camel@kernel.org>
Subject: Re: Fixing a corrupted file system
From: Amit Shah <amit@kernel.org>
To: remi@georgianit.com, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Date: Thu, 02 Apr 2026 20:52:29 +0200
In-Reply-To: <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
	 <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
	 <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-04-02 at 14:32 -0400, remi@georgianit.com wrote:
>=20
>=20
> On Wed, Apr 1, 2026, at 5:21 PM, Qu Wenruo wrote:
>=20
> >=20
> > Nope, btrfs will only try extra mirrors, but in your case your
> > metadata=20
> > doesn't even have extra mirrors.
> > Which is not common, as the default btrfs mkfs profiles will go DUP
> > for=20
> > metadata.
>=20
> I forget what mkfs version, but the default behaviour changed a few
> years ago so the default profile is Single on SSD's. (Correct me if
> this has since been reverted.)=C2=A0 Something about the way SSD's copy o=
n
> write, the DUP entries would end up on the same physical block, so
> the redundancy was not effective.

Right, the man page continues to mention that now as well.

		Amit
