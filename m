Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897BA3914ED;
	Sat, 17 Oct 2026 04:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792209953; cv=none; b=QCM0SpJMosvTicB27CeOPhVmHrRSIq8tsEhLyQnIXjUpC9rK05HjttoP7AeVcBUM91kFYckIYAYXrY08ytYNHRgz0aS0rZUvrp65OtNpESaYsb3jcekLhBv0BUo8oakOx/hYIZ98H1kkOSW7zNvkEl5+nJURpXr1qUJ0ccyB+Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792209953; c=relaxed/simple;
	bh=69crhIeeruaw8Qw0atksroR30WeIWYguZGzsRj5LTmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbsAQ78juXAch/uI1tvNT7YukSBlGqR5K5sJoc87597w4c7S7lviQuC18Va3iOnwTT1aBO1tVVEXoeKM8qIf+hFQufTFnP2ZDv0iEZAdCJngwZVuieHpAmn85mzrorlK1v9eb9QGyTBUaIbyZwM4wBn10ERwpsGZRWIVpLWoHvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U48ntwjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U48ntwjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35FE1F000C4;
	Sat, 17 Oct 2026 04:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792209952;
	bh=nYIISnqN+wnw2FIi/PrsU2Hf3ONQzYIx6wG0iA4EVh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U48ntwjl7h057XfiRjftcXqJrvy89yMTsjyFZYmznlqviFj2ZrdPfXqMPJah8OyT1
	 4FFwDHFsuk452T3fL30piVxyxZaOkDPcQgX1lO8hud0JDXLkfraprL1dod/USGfifR
	 emVnznBLRZmvAwAfN0rwCs0RgQ7lDYNVKVOdu06O4AXxh6G4AqCSpy7RQw0Xs/gsPS
	 QGSNnLtx62JE5/6NaDPRoT0GHhfscxWv1KY1LjjWipXvjYoZLfYuHTSzFhXkFKCV09
	 U0c61FsARrU07zJVjcv+/RDsiwnSlK010Q7bmgFtnIllVsOhRExWoNqQKiasNkPUag
	 CUP3gmfJ9Vu7Q==
Date: Fri, 16 Oct 2026 21:05:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
Message-ID: <20261017040550.GB29318@sol>
References: <20261011222613.10793-1-wqu@suse.com>
 <20261016074756.GD3049@sol>
 <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com>
 <20261016082422.GA1894@sol>
 <4cafa46b-2bdc-4a91-9f33-85d4cb5f9357@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4cafa46b-2bdc-4a91-9f33-85d4cb5f9357@gmx.com>

On Fri, Oct 16, 2026 at 07:24:32PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/10/16 18:54, Eric Biggers 写道:
> > On Fri, Oct 16, 2026 at 06:35:05PM +1030, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/10/16 18:17, Eric Biggers 写道:
> > > > On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
> > > > > +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> > > > > +	"btrfs: fix the fsverity callback where unexpected range is verified"
> > > > 
> > > > Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
> > > > passes.  Under what circumstances will this test fail?
> > > 
> > > It need as least 7.2 upstream, which enables large data folios for btrfs by
> > > default.
> > > 
> > > And I can always reproduce it here, mind to provide more info about the
> > > passed run?
> > 
> > This is on the latest mainline (2f2f7eeef8b0).  Not sure what else
> > you're looking for.
> 
> It can be racy, since the fsverity call is at endio time, if all the endio
> of the same large folio is called after all the reads of the folio finished,
> it can also pass the verification.
> 
> But I don't think it's that possible, unless you have blazing fast storage.
> As the first hole read should trigger the verification for the whole folio
> and trigger an fsverity error immediately.
> 
> I can enlarge the file size, or even git it a loop to run multiple times,
> but I just can't figure out why...
> 
> Or is it possible that the kernel config doesn't have
> CONFIG_TRANSPARENT_HUGEPAGE?

Indeed, I didn't have CONFIG_TRANSPARENT_HUGEPAGE enabled.  Enabling it
makes the test fail as expected.  Maybe would be helpful to mention that
prerequisite in a comment in the test.

- Eric
