Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D02DECC2;
	Wed,  5 Aug 2026 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941718; cv=none; b=tfTeE3LL4lmwbv9F31WWTASI4feuIJF4YX1PBN+HxOPkn/ocPhi5O2yEcXCy8xBg6lssta8ToiqfhIGcJUvd3n+8gAG6u0hPGCDAOV5HR/vgDRssZaCogm+8ea/r5T32LbIKi2A7Rv3rNY5vPamQYb5i1eyoAazLiBYSEXKKlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941718; c=relaxed/simple;
	bh=BF0Nk90y0h4GcExwTjaldih/Q7bfOUwtP9qASVmN5bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faiFy2D5jPQHlcnlfgGEPyx4FLDGhI6t86mHTepPZs4BKLP3x+LBvi4AVo/zxRpCUrzGD+YydXCrlelIb65XoEgvw4hl5fZNX3eKfrnlxdWW66ow9PJJwo+92eOWE7vgrxHFx7tZt9o3TtzgaFAQ7UCJn+ic0LEFUDfTK6u5oeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbLLEhqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbLLEhqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB981F000E9;
	Wed,  5 Aug 2026 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785941717;
	bh=XlmHiv4mjTkTpfOn3oc0LN0jIG6bATtyl43zTRhgtOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lbLLEhqKnHey+fZhyi33F8YfEKwwBK9QkZqC1ctWOEdN8Iya88jK5hDcXQ8EAnKrN
	 ORN5oJ8MLRwX6RxXYDXv9ofBe56UJeXJeI3Hg5ZohTp9aM2EcnyF3/Wi3R2TmOVP7O
	 QGwsa00flZyyvEG6y1Q52+5eumlTV+h+zg+2n6jauHZOdTilt1QWauT7PmDHM9kkfv
	 wu/KMpVbzVrgxGZHfXyyQgpZHh+boRY2BJW3IlSLb3tA75a94H9vCN9hjwiea4b6En
	 iee+Qyy8qZ5N+EUC0mxBJTywuHkVSiG9VzfSmYPXb3PVwpshQ/4DpF0iCGDHqZVHEa
	 NRfigZq7WcO1w==
Date: Wed, 5 Aug 2026 22:55:07 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] fstests: add a dio-read-into-mmap and sync race test case
Message-ID: <anNFEruUSvQ9Xh5r@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260725110724.75124-1-wqu@suse.com>
 <anBiV3ta3qe5Kzfo@zlang-mailbox>
 <3d4d0167-8acb-44bd-9224-78561ddae4bb@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d4d0167-8acb-44bd-9224-78561ddae4bb@gmx.com>

On Tue, Aug 04, 2026 at 09:11:24AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/3 20:05, Zorro Lang 写道:
> > On Sat, Jul 25, 2026 at 08:37:24PM +0930, Qu Wenruo wrote:
> > > There is a report that on btrfs, if the following workload are running,
> > > btrfs can fail:
> > > 
> > > - A dio read into a mmaped range
> > >    Only the mmap range needs to be on btrfs.
> > >    The dio read source makes no difference.
> > > 
> > > - Sync_range on the mapped range
> > > 
> > > The btrfs errors include:
> > > 
> > > - Hang during data writeback
> > > - Filesystem flips RO
> > > 
> > > The mmap range is dirtied but written back by the sync_range process,
> > > then dio read finished and found that the folios are no longer dirty,
> > > so dio endio will mark those folios dirty again so that the fs can write
> > > them back again.
> > > 
> > > However for non-experimental btrfs with 4K block size and 4K page size,
> > > there is a regression in v7.2 that such case is no longer handled
> > > properly, due to the enablement of large folios and removal of cow
> > > fixup.
> > > And btrfs can never handle it for bs < ps from day 1.
> > > 
> > > Add a regression test for it.
> > > 
> > > Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > 
> > Hi Wenruo,
> > 
> > Thanks for this new test!
> 
> Thanks for the review. Will update the patch to address all the comments and
> refresh the test number.
> 
> But one comment inlined below.
> 
> > > +
> > > +kill "$read_pid" "$sync_pid" &> /dev/null
> > 
> > How about:
> >    kill -TERM -"$read_pid" -"$sync_pid" &> /dev/null
> > ?
> > 
> > As the (man 1 kill) says:
> > 
> >    pid
> >      Each pid can be expressed in one of the following ways:
> >      ...
> >      -n
> >         where n is larger than 1. All processes in process group n are signaled.
> >         When an argument of the form '-n' is given, and it is meant to denote a
> >         process group, either a signal must be specified first, or the argument
> >         must be preceded by a '--' option, otherwise it will be taken as the
> >         signal to send.
> > 
> > I didn't give it a try, but I think this might help to kill the
> > dio-read-into-mmap and sync_range process too.
> 
> Unfortunately this doesn't seems to work.
> 
> If I removed the redirection, it shows the following error:
> 
> /home/adam/xfstests/tests/generic/801: line 76: kill: (-1271) - No such
> process
> /home/adam/xfstests/tests/generic/801: line 76: kill: (-1272) - No such
> process
> 
> Thus it will not really kill the children processes.
> 
> Despite this change, all other comments will be addressed.

Hi Wenruo,

Sorry for the confusion! I assumed that approach would work, but from the
error message, it seems running "read_workload &" doesn't create a proper
Process Group (PGID).

How about this approach instead?

1) kill -TERM "$read_pid" 2>/dev/null

Based on the trap in read_workload(), it should enter "wait" upon receiving
SIGTERM, preventing any new iterations of the loop. Then we can run:

2) pkill -P "$read_pid" 2>/dev/null

to clean up any remaining child processes, followed by a wait for the main
process to exit.

3) wait "$read_pid"
   unset read_pid

(We can wrap this logic in a function and invoke it inside _cleanup)

I hope this can prevent the script from waiting long time, and no orphaned
processes are left behind. Feel free to tell me if anyone has better idea :)

Thanks,
Zorro

> 
> Thanks,
> Qu
> 
> > 
> > (same in _cleanup)
> > 
> > > +unset "$read_pid" "$sync_pid"
> > 
> > unset read_pid sync_pid
> > 
> > > +wait
> > > +
> > > +echo "Silence is golden"
> > > +_exit 0
> > > diff --git a/tests/generic/799.out b/tests/generic/799.out
> > > new file mode 100644
> > > index 00000000..f3fd9fa2
> > > --- /dev/null
> > > +++ b/tests/generic/799.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 799
> > > +Silence is golden
> > > -- 
> > > 2.51.2
> > > 
> > > 
> > 
> 
> 
