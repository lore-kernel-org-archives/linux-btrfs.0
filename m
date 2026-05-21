Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2D0202F70
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368012; cv=none; b=t/JoEbPdHTJ2yVLqBnP5PgfhYsrFiiLzVy6I95CvU8FqjzQ2IRPrhDcwyrlIjoi8EyGo/Z8LEfs2f8AueR/0eIJfRPk/WzckVXnCMT8Uov63+1xDuVTr9fMaty5CPgUEvRWDsIjs6v/KUnGCWPYUbKnF3BpDneDupNmj3YfVNB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368012; c=relaxed/simple;
	bh=CY70IBDdCJkrvHoe5He9fUVnZK/HTXh7g9YjNip0yzA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=chLJr1qeZTZxTetpiVsN+3HmUyYJd4mnzfYTO/RiWTstdBf6/WP4ySRdTPUeUfn3khyWk0ZiawgXUmzLncbtO01AZvIyUgGiF+SHGCeTYh8NQWUnY9aAxqc0Tv/i41fCX4Ie07G9VsAbdjsa02nWtky4fBS8S8bsM8wdSSpjsUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9HfmNPY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9HfmNPY"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso45666735e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 05:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779368009; x=1779972809; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Po8bRY+2Zw7SpFByHj9bdyPqMpAiAdE/4HeoUagAzVY=;
        b=d9HfmNPYVE4G3Apq+449xPBT1SkEeMX6pBRg6bKAng0pdPJriwmGnGcuj4Xs3s7yfG
         SQLxp9yuPZVvNeJbvUpVpCdop/sU+vD0ywdeMm9QPePstOmKnCqLznZs89mgjD6OyHZS
         QUSU2JHkd8elENnDuy7UBb+i1cYvZWR4Jcu8QrGKTSBz4GWZkbks2SSq9OLKezjrBbeP
         w7reuyqneTeWmhqPXNaWokd6WyNdpzNt1xWj9/czVUDTrfPCotuaCQfFVKtOkUD0ShX2
         xq6sIGT0TrSQihOcH8FL0dLlrsCW2Ep8BXaZkicOCgKL8UbXO0/Sxs2P27LJlVqj0znV
         EG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368009; x=1779972809;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Po8bRY+2Zw7SpFByHj9bdyPqMpAiAdE/4HeoUagAzVY=;
        b=o50ysLhx/wkbc632TC6/9r0F7/ta4atC0XVCsdNJ3HATX84WAH1lcD40rgGFXhdjNU
         1vvhCmAkW+FkxpuWa9GuQI3nIaAyHWyG3NgRQWmF9V9JCOI6Tuje6bk9G8eSJ82yHwDT
         K41ybDbdw2aXw7KwkOxa4TcsxA2nYhnlV4dRrX69GjfZxq1a3q/Bu18//LUSL5Z6SFOH
         6lLZrc+btNRZUtBfR9LY3tDWkEZrZp5a1V9sSrbnVHvCqYDlEZ7cJTf6QUXmiLxN5cXq
         l4JMLkYrjxmBzWmgBC7IgdXJy8tGqqMIjQAd7lUPIcNN1+YBv1xfxgTJrZb3mHgaGSwh
         6xPQ==
X-Gm-Message-State: AOJu0YyFmrFKnw/G6T1jYLflGe1KpcTfLF73sf7DG6VLe26FY7RBpDyJ
	o8r+nSGooiCtTcNS2sRQAnTJuMy3I4igDX1g5mdZdpsTuoFP+MeqBnNEVcs7YA==
X-Gm-Gg: Acq92OH92fc1PTcEzAccbhjymvme+b35oZ7f1TH/hLb4Q3Ngjmwq4DM7s//pue8GacM
	vgcFfDNJpHxL5Uq/70TjbxH+/OOXbC14p2c6pHiXH8kaAFeqnQ0JW0i5UYYn1+36sXcVo+GQ5DF
	m+DY9NxCtxQeWvhjJwhGat+wLo1izCtrfAuv/Mc/z2ve7PnA/evlxGEs2+4RQd2ycNwxwNHsMS4
	pYcm+4p5MmkiAB+gjI4pHwnimJeK3gAZKb7DXJzNSzwOna8arph7Y0DkCBdp+NOHGix8P7qTc5Y
	N8yZiVXzIL3FScSKa0F09PP1HGd04XQ42P0n276RVV8RX5AI5cKSgmxw4qeC3c6K4N6YfS2kEEQ
	SFdymU7aT/HBMUHXcJFlQIg00JDvlKhOsnQIHBcD/rbA0Bp2zFKW639U2lsjqcncriVw/rGSfEc
	qV6k85EKPCZKw038sKSnXxOl1Z0C2KCC72Og==
X-Received: by 2002:a05:600c:37c4:b0:489:1f08:91b with SMTP id 5b1f17b1804b1-490360a87a0mr42463605e9.16.1779368008985;
        Thu, 21 May 2026 05:53:28 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035eec6casm15437265e9.33.2026.05.21.05.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 05:53:28 -0700 (PDT)
Date: Thu, 21 May 2026 15:53:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: refactor __btrfs_run_delayed_refs loop
Message-ID: <ag8ARRwykv8bpJ87@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[ 8 year old code and no one has complained...  It's surprising no
  one has hit this in real life. - dan ]

Hello Nikolay Borisov,

Commit 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
from Aug 15, 2018 (linux-next), leads to the following Smatch static
checker warning:

	fs/btrfs/extent-tree.c:2131 __btrfs_run_delayed_refs()
	error: 'locked_ref' dereferencing possible ERR_PTR()

fs/btrfs/extent-tree.c
    2084 static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
    2085                                              u64 min_bytes)
    2086 {
    2087         struct btrfs_fs_info *fs_info = trans->fs_info;
    2088         struct btrfs_delayed_ref_root *delayed_refs;
    2089         struct btrfs_delayed_ref_head *locked_ref = NULL;
    2090         int ret;
    2091         unsigned long count = 0;
    2092         unsigned long max_count = 0;
    2093         u64 bytes_processed = 0;
    2094 
    2095         delayed_refs = &trans->transaction->delayed_refs;
    2096         if (min_bytes == 0) {
    2097                 /*
    2098                  * We may be subject to a harmless race if some task is
    2099                  * concurrently adding or removing a delayed ref, so silence
    2100                  * KCSAN and similar tools.
    2101                  */
    2102                 max_count = data_race(delayed_refs->num_heads_ready);
    2103                 min_bytes = U64_MAX;
    2104         }
    2105 
    2106         do {
    2107                 if (!locked_ref) {
    2108                         locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
    2109                         if (IS_ERR_OR_NULL(locked_ref)) {
    2110                                 if (PTR_ERR(locked_ref) == -EAGAIN) {
    2111                                         continue;

In the old we set "locked_ref = NULL" on this path and I think we
probably should restore that line.  Now it looks like a crash.

    2112                                 } else {
    2113                                         break;
    2114                                 }
    2115                         }
    2116                         count++;
    2117                 }
    2118                 /*
    2119                  * We need to try and merge add/drops of the same ref since we
    2120                  * can run into issues with relocate dropping the implicit ref
    2121                  * and then it being added back again before the drop can
    2122                  * finish.  If we merged anything we need to re-loop so we can
    2123                  * get a good ref.
    2124                  * Or we can get node references of the same type that weren't
    2125                  * merged when created due to bumps in the tree mod seq, and
    2126                  * we need to merge them to prevent adding an inline extent
    2127                  * backref before dropping it (triggering a BUG_ON at
    2128                  * insert_inline_extent_backref()).
    2129                  */
    2130                 spin_lock(&locked_ref->lock);
                                    ^^^^^^^^^^^^^^^^
On the next iteration &locked_ref will be ERR_PTR(-EAGAIN).

--> 2131                 btrfs_merge_delayed_refs(fs_info, delayed_refs, locked_ref);
    2132 
    2133                 ret = btrfs_run_delayed_refs_for_head(trans, locked_ref, &bytes_processed);
    2134                 if (ret < 0 && ret != -EAGAIN) {
    2135                         /*
    2136                          * Error, btrfs_run_delayed_refs_for_head already
    2137                          * unlocked everything so just bail out
    2138                          */
    2139                         return ret;
    2140                 } else if (!ret) {
    2141                         /*
    2142                          * Success, perform the usual cleanup of a processed
    2143                          * head
    2144                          */
    2145                         ret = cleanup_ref_head(trans, locked_ref, &bytes_processed);
    2146                         if (ret > 0 ) {
    2147                                 /* We dropped our lock, we need to loop. */
    2148                                 ret = 0;
    2149                                 continue;
    2150                         } else if (ret) {
    2151                                 return ret;
    2152                         }
    2153                 }
    2154 
    2155                 /*
    2156                  * Either success case or btrfs_run_delayed_refs_for_head
    2157                  * returned -EAGAIN, meaning we need to select another head
    2158                  */
    2159 
    2160                 locked_ref = NULL;
    2161                 cond_resched();
    2162         } while ((min_bytes != U64_MAX && bytes_processed < min_bytes) ||
    2163                  (max_count > 0 && count < max_count) ||
    2164                  locked_ref);
                          ^^^^^^^^^^
We continue down to here and loop back since locked_ref is -EAGAIN.

    2165 
    2166         return 0;
    2167 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
