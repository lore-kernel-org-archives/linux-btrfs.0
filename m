Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792464;
	b=SAPdyoBvco3DxO/eS2znyk6sFO4G+l1xYXJbu/upIqn1EYNOHJmoROqURT1fFpavuToz
	 Mhao4DGc4vja79MNtnhjVzKvfCchR2WzVW5AQXtq+xIbKSCwc6MLh85z7E1ccVpFY0PqE
	 OVW5WVdKUepDvdDRA/2dTk73FDLvPmUnCgyX4AIPe4sZNT1UVXX14hQxWDwTJ5e8vP4q2
	 T072Ikr/KVf1d2t2+DYHToz7E9LVMUy0qV8PHUlog7KxQizuzql7etlREI7kwAeEA4KPn
	 MM1Wf2w9JHlw34TyjPTzMA6k4yvhPfh1wOhXnh+Fk5BAg/8Ou2+mSG8Z3bLSdFFPizA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792464;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=kSLkYTmeXJUswQ2rARcJsWMhB6HEcBE1ds40+teSZTk=;
	b=bhWZSaVKqPpafnQbccALBR1cEjXlIHGkMzxdHIcONBZh+/n4qtHkjTKN2oiNurWbNJCR
	 B0IKhOqlpBcEuc/fAk7YDeJK92D6Z+uHarDtyilacAEf5YfTu36NlY/U7jiSp5ilbvJm2
	 wvs8EbgxMl9seHBqsKZaUta1wINshFiPR1K2GsnyGn78YktKjcSmiWzk0/gO5ujTEPHGC
	 z2WJ71DKX3LXUWdk1S8s41FrxhOfqQ8mhlcr348m6lTk86XTJ18+Rk3YJXHukAwvKDM5a
	 X2fttCFcXollPJXGWPljkAe1o5QSFGV2BymFIK3oIFwYyhw8dhb4Rsrkdbn7OHWv5iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMcuaXvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F60606A31C;
	Fri, 27 Nov 2026 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMcuaXvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2211F00893;
	Fri, 27 Nov 2026 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795792463;
	bh=kSLkYTmeXJUswQ2rARcJsWMhB6HEcBE1ds40+teSZTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YMcuaXvR3/hiinQIhmYbg6FblsNgGHqqFFaOIhFU81Yzv5kTfY59LuYzpFjqWSxqy
	 uVSf+vK4QuzeEBgJ3kjw4XzVQNJQr3XmmTrKDRHUYWyQPsMzTeZVdb2PyTkqk8YuZ4
	 0TG6O6fPobwGu8BRWt5pCuafZZ4CQhCwvyQ1+mgaFp/yfXrS5EoTJOrTGok/U2vA5s
	 c7cGjDofEqHV3UFgnIITQoByTh6kwfbiRxei5gm6191jb4u6PjRLQhonlmrLYLcXSf
	 eNQwmtRVWwY5xak9AmkSK28P7lyTAtLV353Qar//LV4eW6yimqCF51x//0FaMHTRJR
	 65yqQxyU2Uo6g==
Date: Fri, 27 Nov 2026 17:14:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] btrfs: add a maintainer entry profile
Message-ID: <20261127151418.GY774860@unreal>
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
 <20261126133712.GN774860@unreal>
 <978c5ae0-8cf2-47d4-8fb5-1d96896132be@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <978c5ae0-8cf2-47d4-8fb5-1d96896132be@suse.com>

On Fri, Nov 27, 2026 at 08:23:13PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/27 00:07, Leon Romanovsky 写道:
> > On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
> > > This new file is mostly based on my personal preferences, focusing on
> > > how to improve the human readability in the LLM era.
> > > 
> > > The new file should also act as a guide for humans that want to be a
> > > long term contributor to btrfs.
> > 
> > My previous comment still applies. Most of it is relevant to other
> > subsystems as well, and some of the suggestions duplicate existing
> > documentation.
> 
> One question is, I can't find a generic one, nor there is a generic entry
> inside the MAINTAINERS file.
> 
> If we're going to create a generic one, shouldn't we just update the
> existing docs like `Documentation/process/submitting-patches.rst` instead?

See Documentation/process/coding-assistants.rst file.
For example, this series from Sasha changes it
https://lore.kernel.org/workflows/20261126171926.2766137-1-sashal@kernel.org/

> 
> And to be honest, the current one is already a little LLM orient, lengthy
> and not well human reader friendly.

I disagree that file was written before AI era and everyone who
submitted patches or read it was asked to read after first mistake.

> 
> 
> So what's the recommended next step?

Read the documentation :) and more seriously, update Documentation/process/coding-assistants.rst.

Thanks

> 
> Thanks,
> Qu
> 
> > 
> > > 
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > ---
> > > Changelog:
> > > RFC->v1:
> > > - Use maintainer entry profile instead of agent.md
> > > 
> > > - Further simplfy the content for human readers
> > > 
> > > ---
> > >   Documentation/process/maintainer-btrfs.rst | 154 +++++++++++++++++++++
> > >   MAINTAINERS                                |   2 +
> > >   2 files changed, 156 insertions(+)
> > >   create mode 100644 Documentation/process/maintainer-btrfs.rst
> > > 
> > > diff --git a/Documentation/process/maintainer-btrfs.rst b/Documentation/process/maintainer-btrfs.rst
> > > new file mode 100644
> > > index 000000000000..5170dd73e655
> > > --- /dev/null
> > > +++ b/Documentation/process/maintainer-btrfs.rst
> > > @@ -0,0 +1,154 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +Btrfs patch guidelines
> > > +======================
> > > +
> > > +Human readability comes first. A reviewer should be able to understand the
> > > +problem and the fix from the message and code.
> > > +
> > > +Bloated LLM-generated information only wastes precious human time, no matter
> > > +whether it is in a comment or a commit message.
> > 
> > This is general.
> > 
> > > +
> > > +Code comments
> > > +-------------
> > > +
> > > +* **Necessary comment only**
> > > +
> > > +  Comment is for things that are not obvious by itself, e.g. a locking
> > > +  rule, an ordering requirement or a non-trivial reason for a workaround.
> > > +
> > > +  Keep the comment short if possible.
> > > +
> > > +  Don't repeat what the code does.
> > 
> > General too.
> > 
> > > +
> > > +* **Add kernel-doc only for complex and/or exported functions**
> > > +
> > > +  If the function and parameter names are self-explaining, don't waste words
> > > +  on the kernel-doc.
> > 
> > This is applicable to many subsystems, but probably not general.
> > 
> > > +
> > > +Commit messages and cover letters
> > > +---------------------------------
> > > +
> > > +* **Keep it simple**
> > > +
> > > +  Use short and simple sentences, avoid long paragraphs.
> > > +
> > > +  Simple patch for simple bug. Don't write a full [BUG] [CAUSE] [FIX] analysis
> > > +  for something like a simple error handling enhancement.
> > > +
> > > +  And we don't care how you or your LLM found the bug unless it's hit in the
> > > +  real world, so don't put such information even after the "---" line.
> > 
> > General
> > 
> > > +
> > > +* **Prefer visual aids over long sentences**
> > > +
> > > +  See "Visual aids" section below.
> > 
> > General
> > 
> > > +
> > > +* **Follow the style of well-known btrfs developers**
> > > +
> > > +  Check ``git log -- fs/btrfs`` for recent examples before drafting.
> > 
> > General
> > 
> > > +
> > > +Visual aids
> > > +-----------
> > > +
> > > +Prefer visual aids like an ASCII chart over words, e.g.:
> > > +
> > > +* A race. Show the race window, do not describe it in prose only.
> > > +* An error handling bug in a function, seen from several call sites.
> > > +* A call chain across layers, where the bug only shows on a certain path.
> > > +
> > > +Example, a race::
> > > +
> > > +   CPU0 (endio)                       CPU1 (fsync)
> > > +   end_bbio_data_write()
> > > +   |-btrfs_folio_clear_writeback()
> > > +   |                                  btrfs_sync_file()
> > > +   |                                  |-filemap_fdatawait_range()
> > > +   |                                  | Returns after writeback finished
> > > +   |                                  |
> > > +   |                                  \-test_and_clear_bit(COW_WRITE_ERROR)
> > > +   |                                    Still 0, skips waiting
> > > +   \-set_bit(COW_WRITE_ERROR)
> > > +     Too late.
> > > +
> > > +Example, an error handling bug, from commit c9583ada8cc4. The callee cleans up
> > > +on error, then the caller cleans up again::
> > > +
> > > +   btrfs_do_readpage()
> > > +   |-submit_extent_page()
> > > +   | \-submit_one_bio()
> > > +   |   \-btrfs_submit_data_bio()
> > > +   |     \-bio_endio()
> > > +   |       Calls end_page_read() and unlock_extent().
> > > +   |
> > > +   \-end_page_read() and unlock_extent()
> > > +     Cleaned up again, the subpage reader count underflows.
> > 
> > General
> > 
> > > +
> > > +Versioned patches
> > > +-----------------
> > > +
> > > +* **Full history**
> > > +
> > > +  Include all versions, not only the changes of the last version.
> > 
> > General
> > 
> > > +
> > > +* **Newest version first**
> > > +
> > > +  E.g.::
> > > +
> > > +    v3:
> > > +    - Rename the helper to xxx()
> > > +    - Add a missing lock in yyy()
> > > +
> > > +    v2:
> > > +    - Fix the build failure on 32-bit
> > > +
> > > +* **Changelog location**
> > > +
> > > +  Put it in the cover letter for a patch series, or after the "---" line for
> > > +  a single patch.
> > > +
> > > +  Don't put it in the commit message body.
> > 
> > General
> > 
> > > +
> > > +Review
> > > +------
> > > +
> > > +* **Follow the review**
> > > +
> > > +  Don't send a patch and just forget it. If you're not a well known developer,
> > > +  it's uncommon to get merged on the first try.
> > > +
> > > +  One will need to communicate with the reviewers to get at least one review
> > > +  from a well known btrfs developer, before getting the patch merged.
> > > +
> > > +* **Check Sashiko**
> > > +
> > > +  Sashiko posts AI-generated review for patches sent to the mailing list. The
> > > +  btrfs list is at https://sashiko.dev/#/?list=org.kernel.vger.linux-btrfs
> > > +
> > > +  If a report is valid, address it in a newer version.
> > > +
> > > +  If a report is obviously wrong, it can be ignored. If the report is wrong but
> > > +  the reason is not obvious, explaining it on the mailing list can help.
> > > +
> > > +Testing
> > > +-------
> > > +
> > > +* **Run full fstests**
> > > +
> > > +  That's the main test suite we use.
> > > +
> > > +* **Testing procedures and results are only for complex patches**
> > > +
> > > +  Simple fixes shouldn't need a long paragraph on how to verify the fix.
> > > +  Those simple fixes should be explained well by the commit message and code.
> > > +
> > > +  Bloated LLM-generated test procedures and results only waste human time.
> > > +
> > > +Before sending a patch
> > > +----------------------
> > > +
> > > +* **Check the development branch**
> > > +
> > > +* **Check the mailing list**
> > > +
> > > +If your bug was found by an LLM, someone else may have already found, or even
> > > +fixed, it.
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 44540a1eb2b8..55f0b3dca133 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -5838,9 +5838,11 @@ S:	Maintained
> > >   W:	https://btrfs.readthedocs.io
> > >   Q:	https://patchwork.kernel.org/project/linux-btrfs/list/
> > >   C:	irc://irc.libera.chat/btrfs
> > > +P:	Documentation/process/maintainer-btrfs.rst
> > >   T:	git https://github.com/btrfs/linux.git for-next
> > >   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> > >   F:	Documentation/filesystems/btrfs.rst
> > > +F:	Documentation/process/maintainer-btrfs.rst
> > >   F:	fs/btrfs/
> > >   F:	include/linux/btrfs*
> > >   F:	include/trace/events/btrfs.h
> > > -- 
> > > 2.56.1
> > > 
> > > 
> 
> 
