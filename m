Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794919687;
	b=QruwmnGUxQR3peFSdlcNj8zTmv4kLn+g8MajyHJ/+0JJGEVqMwW8+MK5aTXrteyXRm4q
	 kx1SX9YwAq/PumKFzzAy1tbV5a+q9AlDAULBaBbJW3kcEQB3AG01uLbC7X9kq73bw3Uzx
	 V6wsfjkofVBFpir7os4qiZDuXoEU6GiXN3PaejKp1FyCdXsuUu+qlCzmAu/99pFX25RMf
	 PJWcOKjmFrFu9rw/d+uxtutcoBzua5tUPDteMZ4P2h50/ZZKbimQxlFmnPkVUuBP3HFVk
	 r4wh8KxSAgwKq80t6Ck0iG8jWjDx2AP7ZtS9dPNoGgJ1Gw6Ik0DFnm/OrwGM0q5G2zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794919687;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=h+LNhrt9j/b/RBbUIJw2rBJ8YAb7yE512bAtckM4qj8=;
	b=Ie0JmaF3T0QS1hlarbB4s4VOYHddA+hLfZG1dIvQcmGv7NVpWR36oCww28BKzR77Ctqa
	 fpqjpb6rxxWcPNVRmSij/c475+LOf3LolhDc5LdkFrNVArL5wug6LFgNmzsh3DcIXSY9y
	 cDZPv0uMEy/QrztKELih1UAodwvLMz5s/vH6AYkRXS41Gzc6U5x0uuqPJSbfgt+wKjGza
	 kHqa+iixoOczAYgm0D4zE9x7kyyxWH1Xm06xVjniY7HcTeY+4jNWxAZoQ/PX/UbZgKsnq
	 4cj0tC3Vfq/I8Cg52FO1riVayBVPr9ky9pUl1V9w++/lYAUi1+apNjLiHOhLBcpOgqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGMLG9M2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C2B606A31C;
	Tue, 17 Nov 2026 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oGMLG9M2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0B21F000C5;
	Tue, 17 Nov 2026 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919686;
	bh=h+LNhrt9j/b/RBbUIJw2rBJ8YAb7yE512bAtckM4qj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oGMLG9M29TDqNoeM+yuPjKo5c4seh1igfIH9fgAYAGpOoHF+2aJgNXbh9vXAiyMuM
	 AfmRvGTOA6liS3jHoUkorFO1IJDf6loVBLdA8cR1acVeSqc0RRyja8jk+rEKYaBWAJ
	 q2wskywmb7FHcjm3j8rNDvT1xvvReG8aYtbCTCdKpdVfK7dU5h7rZiP8RL2z3T+IvC
	 Ild3az7V+Iagp0CtQJsmhxZc2ymG/O8rm4qTA5E8+NUIrgIc6PdlSrKjsvQqrlA/X4
	 hzEj6D0JkRX19QaRx1u48HD+eqj4wnYC2nvL3LOKeCDsPoQc46EdSB/mev/AQU/QDK
	 rmFCD2svCgKzQ==
Date: Tue, 17 Nov 2026 11:37:42 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] btrfs: add a per-subsystem agent file
Message-ID: <20261117093742.GC124972@unreal>
References: <df1c1fa031ba7e66486348dc37d1a7be53c18e43.1794894953.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df1c1fa031ba7e66486348dc37d1a7be53c18e43.1794894953.git.wqu@suse.com>

On Tue, Nov 17, 2026 at 04:28:18PM +1030, Qu Wenruo wrote:
> I believe btrfs is not the most affected sub-system, but a lot of
> newbies without common senses are doing more harm than help.
> E.g. wasting a lot of human review time on very low value fixes, filled
> with long paragraphs and useless test steps/results.
> 
> So it would be better to let those agents to stop being stupid and
> follow the more common practices here, and hopefully those newbies can
> build some common sense.
> 
> I hope the agent file is clear and short enough, that is not only
> readable for LLMs, but also for humans who want to be long term
> contributers.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Reason for RFC:
> 
> Some practices are my personal preferences, like prefer ASCII charts
> over long paragraphs, and short sentences/paragraphs.

It looks like general descriptions to me and can fit other subsystems too.

Thanks

> 
> But I guess some of btrfs developers may not even agree on my
> preferences.
> 
> Thus feed back from well known btrfs developers are always appreciated.
> ---
>  fs/btrfs/AGENTS.md | 136 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 136 insertions(+)
>  create mode 100644 fs/btrfs/AGENTS.md
> 
> diff --git a/fs/btrfs/AGENTS.md b/fs/btrfs/AGENTS.md
> new file mode 100644
> index 000000000000..d527b862d9bc
> --- /dev/null
> +++ b/fs/btrfs/AGENTS.md
> @@ -0,0 +1,136 @@
> +Btrfs patch guidelines
> +======================
> +
> +These rules apply to any code, commit message or cover letter touching
> +fs/btrfs. They come on top of the top-level AGENTS.md and
> +Documentation/process/coding-assistants.rst.
> +
> +Code comments
> +-------------
> +
> +* Add a comment only when the code is not obvious by itself, e.g. a locking
> +  rule, an ordering requirement or a non-trivial reason for a workaround.
> +* Keep it as short and simple as possible, but do not cut the reasoning a
> +  reader needs, e.g. for locking rules or races.
> +* Do not restate what the code does. Do not narrate the change, and do not
> +  add comments like "fix for ..." or "new helper to ...".
> +* Remove any comment that does not carry information, but only in the lines
> +  being added or touched. Do not drop unrelated existing comments.
> +* Add kernel-doc only for complex functions. Do not bother for simple helpers
> +  whose function and parameter names are self-explaining.
> +
> +Commit messages and cover letters
> +---------------------------------
> +
> +Human readability comes first. A reviewer should be able to understand the
> +problem and the fix from the message.
> +
> +* Use short and simple sentences. One idea per sentence.
> +* Skip filler and long background.
> +* Prefer a small chart or call trace over a long paragraph, see "Visual aids"
> +  below.
> +* Drop any sentence the reviewer does not need to understand the change.
> +* Do not use the [BUG], [CAUSE] and [FIX] section tags for simple bugs. Write
> +  plain paragraphs instead. Keep the tags only for complex bugs, where the
> +  symptom, the cause and the fix each need several paragraphs.
> +* Follow the style of well-known btrfs developers:
> +  * The subject starts with "btrfs: ", is lower case after that, and is
> +    imperative and specific, e.g. "btrfs: fix use-after-free when ...".
> +  * Keep lines within 75 columns. Quoted text (dmesg, error messages, stack
> +    traces) has no limit and must not be folded.
> +  * Check `git log -- fs/btrfs` for recent examples before drafting.
> +
> +Visual aids
> +-----------
> +
> +Prefer anything that makes the message easier for a human to read. An ASCII
> +chart is a good choice when it explains the problem faster than prose, e.g.:
> +
> +* A race. Show the race window, do not describe it in prose only.
> +* An error handling bug in a function, seen from several call sites.
> +* A call chain across layers, where the bug only shows on a certain path.
> +* The order of steps in a transaction commit or a log replay.
> +
> +Chart rules:
> +
> +* Function names only, no file paths or line numbers.
> +* Show only the functions that matter.
> +* Describe a state or outcome with plain text under the function name.
> +* For a race, use one column per racing context (CPU, task, endio), side by
> +  side.
> +
> +Follow the style of the examples below.
> +
> +Example, a race:
> +
> +```
> + CPU0 (endio)                       CPU1 (fsync)
> + end_bbio_data_write()
> + |-btrfs_folio_clear_writeback()
> + |                                  btrfs_sync_file()
> + |                                  |-filemap_fdatawait_range()
> + |                                  | Returns after writeback finished
> + |                                  |
> + |                                  \-test_and_clear_bit(COW_WRITE_ERROR)
> + |                                    Still 0, skips waiting
> + \-set_bit(COW_WRITE_ERROR)
> +   Too late.
> +```
> +
> +Example, an error handling bug, from commit c9583ada8cc4. The callee cleans up
> +on error, then the caller cleans up again:
> +
> +```
> + btrfs_do_readpage()
> + |-submit_extent_page()
> + | \-submit_one_bio()
> + |   \-btrfs_submit_data_bio()
> + |     \-bio_endio()
> + |       Calls end_page_read() and unlock_extent().
> + |
> + \-end_page_read() and unlock_extent()
> +   Cleaned up again, the subpage reader count underflows.
> +```
> +
> +Versioned patches
> +-----------------
> +
> +* Always provide the full history, not only the changes of the last version.
> +* List every version, newest first, e.g.:
> +
> +  ```
> +  v3:
> +  - Rename the helper to xxx()
> +  - Add a missing lock in yyy()
> +
> +  v2:
> +  - Fix the build failure on 32-bit
> +  ```
> +
> +* Put the history in the cover letter, or after the "---" line for a single
> +  patch. Do not put it in the commit message body.
> +* For a series, keep the cover letter history complete. For a patch changed
> +  in a later version, also keep that patch's own history after its "---" line.
> +
> +Sashiko review
> +--------------
> +
> +Sashiko posts AI-generated review for patches sent to the mailing list. The
> +btrfs list is at https://sashiko.dev/#/?list=org.kernel.vger.linux-btrfs
> +
> +* The submitter should check Sashiko for bug reports on the posted patches.
> +* If a report is valid, address it in a newer version.
> +* If a report is wrong, it can be ignored. A reply on the mailing list only
> +  makes sense when the report is complex or the reason is not obvious.
> +
> +Testing steps
> +-------------
> +
> +* For minor and simple bugs, there is no need to add any testing steps. This
> +  applies to the commit message and to the text after the "---" line.
> +* A minor bug is one that does not affect normal use cases, e.g. an
> +  unlikely error path, a corner case that needs fault injection, a tracepoint
> +  or a debug-only problem.
> +* Testing steps are only appropriate for a complex bug that can be hit in
> +  normal use or have a deep impact, and also when they help the reviewer to
> +  reproduce it.
> -- 
> 2.56.0
> 
> 
