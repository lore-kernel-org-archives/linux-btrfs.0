Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333983;
	b=5pOv58Bu2p7xWPxqrePdw90Eosvt58Z2cz8QuPqJvsw4q9f8z7BRsGyEkITJqkekSzPT
	 lmZVWOTbuPTCOe44bfX3lI0BBdmwCbtx8nGI9/ldlrW8QLi4bhooZQMi90EzigApnmSPR
	 iYCxjczhrA2qyk5r5dMeKhGEedeLP6Az59yjryVpk/WN9zeasqebzJBJbKB8CYX9DJaUX
	 owJziZ+iW8CVhf2VAXVzhzzfXZayuDVF7y7fMqae6AvdJDpOshQ47pYI+mUBOmrnh3Iay
	 QOnyNz98XMPsM2ZdkBbrZT4fcSBzPf7dAIMQRLYMyThUoM7TqwoRVJnUYNu3Aoob4Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333983;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:References:Content-Language:
	 Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PJfqzS64g/n7j0NgWDS1zHAqCKS3AV4yHCGUHEjO/js=;
	b=DDDGTwWtxrVI+y42UR+AD513ygw2o9VJXXpc+4RAbKmwlPTBks+r/Kzlm7jZk4PSuH/3
	 TZIpVnWILWDHJ6YF05uQ9iNgCKqm8TeE+lkp09+EtcuUxeeaFLbmhK8ARjX/RxxodWSoe
	 gdIX4GWJ5sIJb5uCrm0Iievrop3jg2zFC5DVyHog3OW8EgWNNtOURUxXnKonw5G18fbzs
	 36OXtg8mpp8djRw0i3Hp+WeSOqBst/jDetf69E+h4qxkJvhhso6lEUb4Raj58/iejkhzF
	 h1zRWhv46YKOjRk3hUUpyvP0bBa8WOEOEMfPpiw2xi4kHAJgZBWycGOLvfp8CGuHg8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FCCEGpIN;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC56E606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC56E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FCCEGpIN
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c49c32650adso26141366b.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 21:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793333981; x=1793938781; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJfqzS64g/n7j0NgWDS1zHAqCKS3AV4yHCGUHEjO/js=;
        b=FCCEGpINB4sVoT2/AS/O4CT/lpSFtd3NNO/jG8GNjjENHnf2jdFUEKPkFKJ02Et3Vi
         W7AnfV9fesx8LIGsaS+iino+CUiF1biUyfRZo4xUmLk+0vDlnZMuQ2pRlKpfvpB7vDIF
         XfvGxNa4zPF2xJ4P8co5MA+xjZkCF9Wg7Xjk3UBxZL2F8yGhmbQmwSEHDDQphFGf0Z3x
         6L+pag0puNXrXHgb8woKKnX95+WeZSAm+UCwf70BPcRRZK1tfL+GtLtqZt1Yop7RJolS
         4er67HG0ophUkShEndaeisuUVhuGVhEQnQ9bReQ2wg0VJ+zVFfZOFicRskVXq84meWUS
         i2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333981; x=1793938781;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PJfqzS64g/n7j0NgWDS1zHAqCKS3AV4yHCGUHEjO/js=;
        b=xODI+4dAU8LICNZHbFRm7RjRf6sSiJhN+TNXZVr9CCfIZN/pOm+5X1Sp4603GvvpmV
         CnTLPJg2d26X5eWg3iwE3tLDcqPIzibhJVC+3H/N8S6VEiA7PhSlgQiAbgdbWwDLr2sY
         FxnitAWO0hLhABqoz2hVjLnmpXk6YaVyr4uHpYMg5sKkXtem+Q9O2uJA7pWXCbBHIBFu
         JgZOeJY9l1oHji9xfCk6uri+aqVgP1I36HFxpZYB6/MuaEIKuWD7DFyYSX8XyHSzMVgd
         nzc33YoE505C3iWQMwFjmsDCLs/0p9F4sOOmLwQ+srbKq+KviThPXnXAn020WU2d46iN
         TXwA==
X-Gm-Message-State: AFq9FYKtRWWMBLOgQtsuUHgUVbdcRQT0VemjX7zy0R9zb690qv6MPnSZ
	ApbSutLGawFKHMP/7thoOldSO0aA/mUQIfdb3LSyL9OfxggYa1hV36HjfNFzOejJooDhaHhfarw
	FZ58NAzY=
X-Gm-Gg: AYBFou0g7vKhRmaBhhWid3QhzEEKxwrtZ/WvILt9GqCZzK5yoLEhI2ANUMHqR9cGteb
	7AbXdpZ3qajk8rG1ZJu3ezqXmsJtrV8fNGkiUuoeyZlgU+yeO/4YIqVvfoFmf8LZyFd9BWacEhV
	AATLfhRRz1rvsVbpjOyq24RuNoVPRPxL8vQzNRbbWejmpuPpRYT18UzUWNQX91zKfQFT3qvbA2k
	Q+nQ2O9esi1F3xWvN6/EcpL7g+JZC6Lyss7R1H12Pk24oABdWRpy0kyE3nvaCr7tK0QRbQJo5YG
	cDSZzEOIsN8Mexcwk+XQs4qgT6/eBp3CfEFTLQSSrEdsNL/ZGGOOTPs/cEMvCEfraIhve+pkk53
	CWzGbUE5uqFdPSqPfLjcfyF9BNXzXn0iuwcPMc726H9ve2l1z+3zLbI12eJ/4X5M/AdiJTMlfIX
	v1mv1wNUhsaYyuyTMbjQLco+YKoEMz5LgwFizQe/ANC917b+Vd4n6zhrOyz6ExUhIlS8ChwG///
	+bAqVl6C1cfVRJBPeXUNV1oBsJOeTbHIkmRoLLqydssiFuKSD8Du6MTYg9FzudyThWew2tqr6MH
	Nl/LkHHMEyqCrrTIYpD4EQ==
X-Received: by 2002:a17:907:1b08:b0:c3f:a2f0:6cb with SMTP id a640c23a62f3a-c4ca7b1c408mr77673966b.18.1793333981306;
        Thu, 29 Oct 2026 21:19:41 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a9efb3d247sm213488b3a.40.2026.10.29.21.19.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 21:19:40 -0700 (PDT)
Message-ID: <fe13dd4e-ceee-41cd-b0b7-d47e7a0c5426@suse.com>
Date: Fri, 30 Oct 2026 14:49:36 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] btrfs-progs: fix btrfs_path leak, part 2
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1793333606.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/30 14:45, Qu Wenruo 写道:
> This is the part 2, focusing on the on-stack btrfs_path.

This obviously rely on the part 1.

For the full patchset series, one can fetch it from the github PR:

https://github.com/kdave/btrfs-progs/pull/1191

> 
> Unlike heap-allocated btrfs_path, which needs proper btrfs_free_path()
> call, or the btrfs_path itself along with the held ebs will leak.
> 
> The on-stack one only leaks the held ebs, but still we should fix them.
> 
> Just by the amount of code, one should know this is largely generated by
> LLM, although I spent more time drafting the plan and review the final
> patch.
> 
> There are some extra notes other than just converting existing
> "btrfs_path" on-stack declaration to BTRFS_PATH_AUTO_RELEASE:
> 
> - If a label is only for cleanup, remove the label when possible
>    As a lot of call sites can directly return without jumping to the
>    cleanup label.
> 
>    Also cleanup some "ret = x; return ret;" patterns.
> 
> - Keep dedicated btrfs_release_path() if needed
>    As our C code is not fully aligning the path lifespan with the scope,
>    we still need to manually release path halfway for certain call sites.
> 
>    E.g. before calling btrfs_commit_transaction(),
>    btrfs_abort_transaction(), btrfs_search_slot(), close_ctree() or
>    before lowmem mode modifying the tree.
> 
>    Releasing the path before btrfs_commit_transaction() is to follow the
>    kernel convension. There are a lot of existing call sites breaking it,
>    so here we do not intentionally fix them.
> 
>    This will require a dedicated change in the future.
> 
> - Reduce the lifespan of btrfs_path when possible
>    E.g. the path is only utilized inside a loop or if () branch, declare
>    path there.
> 
> This applies to patch 01~08, which are all straightforward conversion
> with minor cleanups.
> 
> After that, the code review process exposed some other bugs in the
> touched functions, which are all pretty simple and low severity ones.
> Patch 09~12 are to fix those minor bugs.
> 
> Qu Wenruo (12):
>    btrfs-progs: kernel-shared: use BTRFS_PATH_AUTO_RELEASE() for on-stack
>      paths
>    btrfs-progs: common, convert, image: use BTRFS_PATH_AUTO_RELEASE() for
>      on-stack paths
>    btrfs-progs: mkfs: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
>    btrfs-progs: tune: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
>    btrfs-progs: cmds: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
>    btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for repair,
>      qgroup-verify and mode-common
>    btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for lowmem mode
>    btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for original mode
>    btrfs-progs: check: fix fixup_extent_flags() retry path
>    btrfs-progs: fix missing transaction commit in
>      truncate_free_ino_items()
>    btrfs-progs: dump-tree: fix exit code and leak on open failure
>    btrfs-progs: check: return error if fill_csum_tree_from_fs() fails to
>      read a root
> 
>   check/main.c                     | 235 +++++++++++--------------------
>   check/mode-common.c              | 141 +++++++------------
>   check/mode-lowmem.c              | 202 +++++++++-----------------
>   check/qgroup-verify.c            |  29 ++--
>   check/repair.c                   |   5 +-
>   cmds/device.c                    |  11 +-
>   cmds/inspect-dump-tree.c         |  11 +-
>   cmds/rescue-chunk-recover.c      |  43 ++----
>   cmds/rescue-fix-data-checksum.c  |  10 +-
>   cmds/rescue.c                    |   7 +-
>   cmds/restore.c                   | 126 +++++++----------
>   common/clear-cache.c             |  79 ++++-------
>   common/root-tree-utils.c         |  10 +-
>   convert/main.c                   |   9 +-
>   convert/source-ext2.c            |   3 +-
>   convert/source-fs.c              |   3 +-
>   image/common.c                   |   2 +-
>   image/image-create.c             |   2 +-
>   image/image-restore.c            |  20 +--
>   kernel-shared/extent-tree.c      |  62 +++-----
>   kernel-shared/file.c             |   3 +-
>   kernel-shared/free-space-cache.c |  24 ++--
>   kernel-shared/inode.c            |   8 +-
>   kernel-shared/print-tree.c       |   9 +-
>   kernel-shared/volumes.c          |  15 +-
>   mkfs/main.c                      |  42 ++----
>   mkfs/rootdir.c                   |  36 ++---
>   tests/btree-test.c               |   2 +-
>   tune/change-csum.c               |  50 ++-----
>   tune/change-uuid.c               |  38 ++---
>   tune/convert-remap-tree.c        |  12 +-
>   tune/quota.c                     |  19 ++-
>   32 files changed, 447 insertions(+), 821 deletions(-)
> 
> --
> 2.56.0

