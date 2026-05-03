Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700EA1F5821
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777822555; cv=none; b=Hj77rJhGXp5xiNNs5MmJ6PDTuIj/LDPcTBGwFkG1teBgQL2sYWFQFdBsQoe3x01w+TW/eKo0il5lXXfEPIsF1QiOsosr7aJE6eB6AJZGFGmr0yr9l0krExZaOOsNfTiI9Vyqjr1JbrHmS+QK44BtHqkHTHzEw3j/sLoM112b38w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777822555; c=relaxed/simple;
	bh=3K1UymCVefvTMFBFVW2e3cV68UAOrq6eEYInWbfGrBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAVjEPpuybenw6/GIx/36QawT1i7d9gBGl4gm3LcaGGgrP4p7u5+uSgO1sM7iVRpziDjz1G/a6KTnohYxiTCJBCwRjg9H3KukL1UGb4h09gbH7vbkz+PEcYR0UCQL/7zcPjsWhwFTFGxFVf6vc60LDPUYnDeBfaCxAlFPLMk6Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BhqbVzRp; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhqbVzRp"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d73352cf2so2998523f8f.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 08:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777822551; x=1778427351; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IA8iXwG9o4NPzKNjWbhLMcYmAXxFWjV4L1239e0Xzn4=;
        b=BhqbVzRptWxD2sjnR399kE4M1NyOA9h/p+8OtUgrsnmipvGJB2/otqhwM7EG6u1a+Y
         u03stfREghQWtUyX+tFv3DwY0GS2lneO8Q5pYQObt624Zo9zllzbX5kOqVJ1oexPBH8x
         ARfK5pmnRzpHVp+sJZuXjQ8Jy5WRyS9oeosrTMAXRohi8cnb5E9MZ69FayRBClQdlHhv
         JEK+1Wk2xHeC8WeeqhhcmmGvVqcK/uodYpcK+KPnLBYHkI0Dj/gTkr6Q4IzSQ+vqeLlq
         RsI6nTq2X4IooSB6taq7Lk3F/AHY9RRIJqINp1mOTbQK9XCJxOtxsoI8swdL0ET/l2tL
         CyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777822551; x=1778427351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IA8iXwG9o4NPzKNjWbhLMcYmAXxFWjV4L1239e0Xzn4=;
        b=GQmyHWkoDo2J7HxpIwdCh/5nx8LjW3RzCQT2NSL4Ce9lkduJw232Dblas8Z4cujXCU
         AirNje3CY/Oa/677il1H1CEvnC25T7SQW6cE/69MSnVS3wrRiZyshwuoCS8PVLJApQ32
         1Lr7AsgNXaynOzsRAHsH7XOJsc+hsTtaGACpGe/QXZAL5f+Tcp+n9VSgMO1t+rHqCYQa
         /oY6X37q5PT2WSeBIuC9vbo5Ytyny6w4IECxY8Troua+e9XYDhQ1JKiBcyHTbwAf0lMS
         cgBSRtaVV7KKhA81TDlcos+mwVSqMLdCPlnhu7IrhUSErzrMUzN+WPpllQV+pyZB2qX/
         UD0A==
X-Gm-Message-State: AOJu0YwGKAXNOpDLU3KKFkjAwRepFG4TIjc9XldzkfKKK4pBxjrLb7pV
	C4X+35SBqiOmZVuYjdN3JD09VxTP1dnDxly6mUDQtVhGFbZMUfqmzIzE0aodFg==
X-Gm-Gg: AeBDievG77l16fNnBlE8lhG5cM/93RlSrnOWuPeyHxiSFiMgKRDoRPGkkPwwfHYQyoK
	yI+H1cNwj4vRj64V1P5MEK4eKknwUUgsbRHUnEtWSSeI1WJU9YXxQ/VOU61npj+2m8ibfyhxP/1
	jQvcvgEqWJ8dwiFCmIVXZN0nfZ57DqaLAdBtr4y8Lb6HNyPvCWKEZWwKIKen0w2Ob+1cHv5tIBE
	M2JhvY3zTF8nwJjWRLsiwfSmnCYdaFI2piGIimID7Qm88E1rR2raJG2JzExGXDDEjv722nD87ct
	vcgy6IpQeUWg7WhLwn9fvHOs72K+ioE7zWY8/RYwHqmnW/QHDmpe4n+Ks5LwqUpUdEGg1Wleyw5
	UrdB7jW+EP9u+uLuNBIAH9Qi2IJ5NA49Ci+xuPJ8NCuFYz92i8W+zWtEb2Upbm7DSCdE8cqqdtH
	+DNdafoRluhE2togVtNqwAhKa7fC97v7poHFb1sOjLb3GT
X-Received: by 2002:a05:6000:2410:b0:441:247a:e98e with SMTP id ffacd0b85a97d-44bb5f26609mr10908893f8f.24.1777822551080;
        Sun, 03 May 2026 08:35:51 -0700 (PDT)
Received: from rabbitArch ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8bf18c9bsm18973072f8f.0.2026.05.03.08.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 08:35:50 -0700 (PDT)
Date: Sun, 3 May 2026 17:35:48 +0200
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com, dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
Message-ID: <afdoNU3rQUr0pREJ@rabbitArch>
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427202822.278326-1-27rabbitlt@gmail.com>

On 2026-04-27 22:24, Teng Liu wrote:
> get_new_location() uses BUG_ON() to crash the kernel if the file extent
> item it looks up has any of offset, compression, encryption, or
> other_encoding set. The data reloc inode is only written by relocation's
> own paths -- insert_prealloc_file_extent() and
> insert_ordered_extent_file_extent() -- which always leave those four
> fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
> and encryption/other_encoding are reserved-and-zero). Observing a
> non-zero value therefore means the leaf decoded from disk does not match
> what the kernel wrote, i.e. on-disk corruption. A malformed image can
> reach this code via balance and panic the kernel.
> 
> Move the validation into tree-checker's check_extent_data_item(), where
> the constraint is enforced when the leaf is read off disk rather than
> after relocation has already started. The data reloc tree has a fixed
> root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
> header, so check_extent_data_item() has all the information it needs to
> apply this check on its own. Report violations via file_extent_err() and
> print the four offending values.
> 
> In get_new_location() replace the BUG_ON() with an ASSERT().
> The caller in replace_file_extents() already handles non-zero returns from
> get_new_location() by breaking out of the loop without aborting the
> transaction, so no caller changes are needed.
> 

Hi Qu, David, and all,

I spent some time trying to understand why the tree-checker saw non-zero
offset while BUG_ON never hit. Share some observation here in case it's
helpful and also ask for further advice about how to make the patch
correct.

Short answer: I noticed that get_new_location() and the tree-checker
look at different itmes in the data reloc tree. The tree-chcker
validates every item pre-write; while get_new_location() searches only
exact cluster boundary key, so the offset is always 0.

== How I tested ==

I instrumented both check_extent_data_item() (tree-checker) and
get_new_location() with pr_info() to log ino+key_offset+offset for every
item. Then ran btrfs/061 on qemu. 

== Some Evidence ==

Tree-checker hits (items with non-zero fields in the data reloc tree):
[   63.531400] tree-checker HIT: ino=258 key_off=13303808 type=1 offset=102400
              compress=0 encrypt=0 other=0

Printing out the leaf items (when tree-checker hit an item with non-zero
offset) and we found:
[   63.540541]  item 114 key (258 EXTENT_DATA 13201408) itemoff 10188 itemsize 53
[   63.540549]          generation 22 type 2
[   63.540554]          extent data disk bytenr 4566134784 nr 110592
[   63.540558]          extent data offset 0 nr 102400 ram 110592
[   63.540613]          extent compression 0
[   63.540619]  item 115 key (258 EXTENT_DATA 13303808) itemoff 10135 itemsize 53
[   63.540644]          generation 22 type 1
[   63.540649]          extent data disk bytenr 4566134784 nr 110592
[   63.540744]          extent data offset 102400 nr 8192 ram 110592
[   63.540750]          extent compression 0

Looking for the two 13201408 and 13303808 items in get_new_location:

get_new_location() search keys:
  ino=258 key_off=13201408 offset=0 type=1
  ...

We didn't see 13303808 item at all during get_new_location.
get_new_location searched for key_off=13201408 (the cluster boundary) and
found offset=0.  It never searched for 13303808.

=== Why this happens ===

During the MOVE_DATA_EXTENTS phase:

1. prealloc_file_extent_cluster() inserts one PREALLOC per cluster
   boundary (via insert_prealloc_file_extent), all with offset=0.

2. relocate_one_folio() reads source data and marks pages dirty.  On
   writeback, ordered extents are created.  When an ordered extent
   completes, insert_ordered_extent_file_extent() calls
   insert_reserved_file_extent(), which calls btrfs_drop_extents() to
   carve out the written range from the PREALLOC, splitting it.  The
   right-hand piece (REG) gets the ordered extent's offset into the
   shared disk_bytenr -- which can be non-zero.

3. The pre-write tree-checker fires when the modified leaf is written
   to disk, seeing the REG item with offset!=0.  This is the false
   positive.

4. btrfs_wait_ordered_range() waits for all ordered extents to finish,
   then the stage switches to UPDATE_DATA_PTRS.  replace_file_extents()
   calls get_new_location(src_disk_bytenr) for each source extent.
   The search key is:

       bytenr -= reloc_block_group_start;
       btrfs_lookup_file_extent(..., ino, bytenr, 0);

   This is the cluster boundary -- the start of an extent, where offset
   is always 0.  get_new_location never searches the mid-range keys
   where the split pieces live.

== Advice Needed ==

If my analysis is correct, what do you think is the best way to fix this
problem? Or am I missing something somewhere?

Thanks in advance,
Teng Liu

