Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6407F3D3D04;
	Sat, 16 May 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778940244; cv=none; b=GemETznLAB/rPrqNtJk5lguR6Nqsu+ue4UZybrxds9TSkhiRj2nh4iKzu9N2f03haCCQgLH2TEaditZeIKlEdfeBD11CR6JTaKGRrydQLr5qJEiAcx5s+sgQMM5QAL4B9B9A6+bTxI0hmT2QrvstniRTxPSp7peAzaSVxLQnMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778940244; c=relaxed/simple;
	bh=Svy9XdLFl0L/1zcUrK1IFrIdZxs/c6Mf3LV+hSsFnlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0djvuRp/IIWUwH+8y8n+uMbVY8XQzilSFfMbXK4mQ51g1p/qgobKnv9wnoSmXKZtL9plcSR5tS+BO7oCGlRaHn4tUdSHueAgTa/aALT4sddsWvjXOXuC1NKoviqha/d2lSqQLP7b0DpSQzKcIv0Hwc8NwMU1t2rpuTWq4EixME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J47eg9cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J47eg9cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927A2C19425;
	Sat, 16 May 2026 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778940243;
	bh=Svy9XdLFl0L/1zcUrK1IFrIdZxs/c6Mf3LV+hSsFnlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J47eg9cOKm0J9ZwvFoSUgHt3WEtsKkn1g7s+pqsPwoUqxx6bPYWUbZWvv0yHb6pKh
	 BOoto9Vs/qgKfzqbn2/d3GJxXOL9nmBWbzOUptsXbhrnGgQst+j+/jLLsbg5Uw1cxZ
	 pn4Z/xHF0Frt608B5FD66eVlf8hn2nBH6ofqyrBlo0aYX8Nbq5obhyA+nJOrw2hxmJ
	 5y+zhxIFu8TmKa29Q3GHFMT/hjxzcM6j2KwswAfQ5WCMcAwOmUg5ebkZczZ+q63GsD
	 4Qw4fvnbh8uRSbv8Kmabg5cFLFIe1GBpu3f+Gp0C7yXYytejnZKi/zY9LyBKIUhphL
	 ZkoSzRe09vFEw==
Date: Sat, 16 May 2026 22:03:55 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Long An <lan@suse.com>
Subject: Re: [PATCH v2] fstests: btrfs/340: add support for older
 kernels/progs
Message-ID: <agh3zgP9C9EPn_HS@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Long An <lan@suse.com>
References: <ed76cf7d6a0ad2a98e5730015dd4fc6514fc2343.1778749477.git.wqu@suse.com>
 <agdOBcKgPn3s7_u0@zlang-mailbox>
 <816ad05a-4c36-480b-8166-d3c94597fb95@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <816ad05a-4c36-480b-8166-d3c94597fb95@suse.com>

On Sat, May 16, 2026 at 08:48:55AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/5/16 02:25, Zorro Lang 写道:
> > On Thu, May 14, 2026 at 06:34:39PM +0930, Qu Wenruo wrote:
> > > The test case will fail on older distros like SLE12-SP5, there are two
> > > problems on the test case itself:
> > > 
> > > - Requires "--sync" option from "btrfs qgroup show" subcommand
> > >    That option was introduecd in v4.9.1, thus there are still some older
> > >    distros using that very old version.
> > > 
> > > - Not all kernels support quick inherit
> > >    The kernel commit introducing the quick inherit is 6.9, thus some
> > >    supported LTS kernels do not have that commit.
> > > 
> > >    In that case qgroup will just be marked inconsistent, this will cause
> > >    the later "btrfs qgroup show" command to output a warning due to the
> > >    inconsistent flag.
> > > 
> > > Fix both problems by:
> > > 
> > > - Require "--sync" option from "btrfs qgroup show" subcommand
> > >    So older distros will just skip the test.
> > > 
> > > - Redirect all output from "btrfs qgroup show" to $seqres.full
> > >    So older kernels can still pass the test case by marking qgroup
> > >    inconsitent.
> > > 
> > > Reported-by: Long An <lan@suse.com>
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > > Changelog:
> > > v2:
> > > - Fix the mismatch between the commit message and the test case change
> > >    Forgot to amend the changes before sending.
> > > 
> > > - Fix a bug in the stderr redirect
> > >    The stdout redirect should be put last.
> > 
> > Sorry, did I miss part of the discussion? Why did v2 switch to notrun for
> > older tools instead of using the compatible `btrfs filesystem sync` from v1?
> > Was there something wrong with the v1 method :)
> 
> The main concern is the progs used in those tests can be really old, I mean
> there is no supported LTS kernel from that time period anymore.
> 
> With that old progs, I'm not confident enough to trust the progs to do all
> the qgroup numbers verification.
> 
> Nor do I even have an environment at hand to compile that old progs.
> 
> That's why in v2 I switch to skip the test case completely if the old progs
> doesn't even support "btrfs qgroup show --sync".

Oh, that explanation makes sense. I trust your judgment on this as a core btrfs
developer. If there are no other review points from the btrfs list, I'll drop v1
and merge v2. Thanks!

Reviewed-by: Zorro Lang <zlang@kernel.org>

> 
> Thanks,
> Qu
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > ---
> > >   tests/btrfs/340 | 8 +++++++-
> > >   1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/btrfs/340 b/tests/btrfs/340
> > > index 872f790cb975..eff76d0b633c 100755
> > > --- a/tests/btrfs/340
> > > +++ b/tests/btrfs/340
> > > @@ -16,6 +16,7 @@ _fixed_by_kernel_commit 68d4b3fa18d7 \
> > >   # For the automatic fsck at unmount.
> > >   _require_scratch
> > >   _require_btrfs_qgroup_report
> > > +_require_btrfs_command qgroup show --sync
> > >   # This will imply mkfs and enable regular qgroup.
> > >   _require_scratch_qgroup
> > > @@ -39,7 +40,12 @@ _btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
> > >   # without marking qgroup inconsistent.
> > >   _btrfs subv snap -i 1/1 $SCRATCH_MNT/subv1 $SCRATCH_MNT/snap1
> > >   echo "After quick inherit:" >> $seqres.full
> > > -_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full
> > > +# Redirect all output to seqres.full including stderr.
> > > +# For older kernels without quick inherit support, it will mark
> > > +# qgroup inconsistent, which will output a warning about the inconsistent
> > > +# numbers. Here we rely on the final btrfs check to catch any qgroup number
> > > +# errors, thus no need to bother that possible warning.
> > > +_btrfs qgroup show -p --sync $SCRATCH_MNT >> $seqres.full 2>&1
> > >   echo "Silence is golden"
> > >   _exit 0
> > > -- 
> > > 2.54.0
> > > 
> > > 
> 
> 
