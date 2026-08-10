Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2262C34D901;
	Mon, 10 Aug 2026 20:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786395271; cv=none; b=RJHFY9GhHN0pY/fdEnvCzKY9ugACcPiQyQb4/iuGV8RsjPWlw46DRMyVWFRik2NO9cD/7BS6It2r6EQOG0P3oemswwXE9AV0xSYCjTQoxVCKgsmyuBJTjplSe2d46WkRbf2uzqrH0rEtIlD92t5/2RR2IYtoqvfsAnOs9hAO8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786395271; c=relaxed/simple;
	bh=+c+LxPTHDzSKPytChvrGDSkzqKoCwTK4LrBajtOrfT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPWqXI3DvX2njezZ4G8/TxCnxsUEdnmGZbQVzMFL22fXi9qYNPkwzIo3mK4iSPhctwYgliWcUGHtkMKzv837roDb0AveBFQCBv3WFDRDWOx1qOSjmvFK0+gD25lF4FRCryqtSwmG7SrvtXokDHlSEFWDuN6upsDwWGFywKz0Ui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNqIVbpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNqIVbpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5DB1F000E9;
	Mon, 10 Aug 2026 20:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786395269;
	bh=mP7UTHAtJEztjp7YRCaK3F2I4ZPQf5z0GvN+PlA1Q74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cNqIVbppUqVwIKgAD+EoNfz8GaJctNOPF6Y/I9F3s+cUuUeT2Cka9YC14CKyz98GZ
	 GCWQhgOK14kU4P4aHgmAQuElJYwpT0dsJt46pXadQOzdE9QUTg2IWZNQMH2mn54Zao
	 1oilUbUPc+fuosZKBtPVhD+Ue4FLuZQD3txV7j2uNfQziYZ7BfuQmymmjIjd5VWOGC
	 HDbIqH3EHAQbfZl/2d6sLdP/Mwan3G8RXW9c94ApAeaunogKu4Bql+bgHbJ9R55mCX
	 +mWzOqKVJ4ug9RCn9EhIou0HCCaRhk6vVhjX4dmGJSBFGAuYmR/X1Ti7do5Crdizkz
	 BGJJ7PKLci6Rw==
Date: Tue, 11 Aug 2026 04:54:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] fstests: add a dio-read-into-mmap and sync race test case
Message-ID: <ano3xpJuE-w7BNR2@zlang-mailbox>
Mail-Followup-To: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260725110724.75124-1-wqu@suse.com>
 <anBiV3ta3qe5Kzfo@zlang-mailbox>
 <3d4d0167-8acb-44bd-9224-78561ddae4bb@gmx.com>
 <anNFEruUSvQ9Xh5r@zlang-mailbox>
 <61ade7aa-0471-48bb-998f-9dbb76d96cec@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61ade7aa-0471-48bb-998f-9dbb76d96cec@gmx.com>

On Thu, Aug 06, 2026 at 06:49:04AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/8/6 00:25, Zorro Lang 写道:
> > On Tue, Aug 04, 2026 at 09:11:24AM +0930, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/8/3 20:05, Zorro Lang 写道:
> > > > On Sat, Jul 25, 2026 at 08:37:24PM +0930, Qu Wenruo wrote:
> > > > > There is a report that on btrfs, if the following workload are running,
> > > > > btrfs can fail:
> > > > > 
> > > > > - A dio read into a mmaped range
> > > > >     Only the mmap range needs to be on btrfs.
> > > > >     The dio read source makes no difference.
> > > > > 
> > > > > - Sync_range on the mapped range
> > > > > 
> > > > > The btrfs errors include:
> > > > > 
> > > > > - Hang during data writeback
> > > > > - Filesystem flips RO
> > > > > 
> > > > > The mmap range is dirtied but written back by the sync_range process,
> > > > > then dio read finished and found that the folios are no longer dirty,
> > > > > so dio endio will mark those folios dirty again so that the fs can write
> > > > > them back again.
> > > > > 
> > > > > However for non-experimental btrfs with 4K block size and 4K page size,
> > > > > there is a regression in v7.2 that such case is no longer handled
> > > > > properly, due to the enablement of large folios and removal of cow
> > > > > fixup.
> > > > > And btrfs can never handle it for bs < ps from day 1.
> > > > > 
> > > > > Add a regression test for it.
> > > > > 
> > > > > Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > > > Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
> > > > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > > > ---
> > > > 
> > > > Hi Wenruo,
> > > > 
> > > > Thanks for this new test!
> > > 
> > > Thanks for the review. Will update the patch to address all the comments and
> > > refresh the test number.
> > > 
> > > But one comment inlined below.
> > > 
> > > > > +
> > > > > +kill "$read_pid" "$sync_pid" &> /dev/null
> > > > 
> > > > How about:
> > > >     kill -TERM -"$read_pid" -"$sync_pid" &> /dev/null
> > > > ?
> > > > 
> > > > As the (man 1 kill) says:
> > > > 
> > > >     pid
> > > >       Each pid can be expressed in one of the following ways:
> > > >       ...
> > > >       -n
> > > >          where n is larger than 1. All processes in process group n are signaled.
> > > >          When an argument of the form '-n' is given, and it is meant to denote a
> > > >          process group, either a signal must be specified first, or the argument
> > > >          must be preceded by a '--' option, otherwise it will be taken as the
> > > >          signal to send.
> > > > 
> > > > I didn't give it a try, but I think this might help to kill the
> > > > dio-read-into-mmap and sync_range process too.
> > > 
> > > Unfortunately this doesn't seems to work.
> > > 
> > > If I removed the redirection, it shows the following error:
> > > 
> > > /home/adam/xfstests/tests/generic/801: line 76: kill: (-1271) - No such
> > > process
> > > /home/adam/xfstests/tests/generic/801: line 76: kill: (-1272) - No such
> > > process
> > > 
> > > Thus it will not really kill the children processes.
> > > 
> > > Despite this change, all other comments will be addressed.
> > 
> > Hi Wenruo,
> > 
> > Sorry for the confusion! I assumed that approach would work, but from the
> > error message, it seems running "read_workload &" doesn't create a proper
> > Process Group (PGID).
> > 
> > How about this approach instead?
> > 
> > 1) kill -TERM "$read_pid" 2>/dev/null
> > 
> > Based on the trap in read_workload(), it should enter "wait" upon receiving
> > SIGTERM, preventing any new iterations of the loop. Then we can run:
> > 
> > 2) pkill -P "$read_pid" 2>/dev/null
> > 
> > to clean up any remaining child processes, followed by a wait for the main
> > process to exit.
> 
> Not sure if pkill is really needed, as the last wait will handle it well.
> 
> 
> So in short, the existing
> 
> kill "$pid"
> wait "$pid"
> unset pid
> 
> is good enough, that's what I did in the v2.
> 
> Although the child processes still need to trap the corresponding signals,
> which is also done in v2.

Hi Wenruo,

`pkill -P` isn't strictly necessary here. The main difference is whether the
parent process sends a signal to the child process before calling wait, to
help it terminate faster. However, if the child process finishes quickly anyway,
sending that signal isn't really required. I'll review v2, thanks.

P.S. xfstests has quite a few places running background bash function like this,
And it's handled a bit differently every time. Maybe we should provide a couple
of common helpers to handle this kind of execution and cleanup.

Thanks,
Zorro

> 
> Finally I have already tested the signal interruption for v2 several times,
> it all properly catch the signal and terminate the children processes and
> the main script without any delay.
> 
> So I think the one used in v2 is working properly.
> 
> Thanks,
> Qu
> > 
> > 3) wait "$read_pid"
> >     unset read_pid
> > 
> > (We can wrap this logic in a function and invoke it inside _cleanup)
> > 
> > I hope this can prevent the script from waiting long time, and no orphaned
> > processes are left behind. Feel free to tell me if anyone has better idea :)
> > 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Thanks,
> > > Qu
> > > 
> > > > 
> > > > (same in _cleanup)
> > > > 
> > > > > +unset "$read_pid" "$sync_pid"
> > > > 
> > > > unset read_pid sync_pid
> > > > 
> > > > > +wait
> > > > > +
> > > > > +echo "Silence is golden"
> > > > > +_exit 0
> > > > > diff --git a/tests/generic/799.out b/tests/generic/799.out
> > > > > new file mode 100644
> > > > > index 00000000..f3fd9fa2
> > > > > --- /dev/null
> > > > > +++ b/tests/generic/799.out
> > > > > @@ -0,0 +1,2 @@
> > > > > +QA output created by 799
> > > > > +Silence is golden
> > > > > -- 
> > > > > 2.51.2
> > > > > 
> > > > > 
> > > > 
> > > 
> > > 
> > 
> 
> 
