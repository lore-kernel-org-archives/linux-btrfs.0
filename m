Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795786503;
	b=klBXb/4b+YkRl3GKa6D4zMlQBmoKl2imGZSD+eVa4d/sJLLtrdVbQtE8E7hM+TCNdklF
	 qgtdHNLCRaAU1bKNxuJDe/jffOB5XiKITtwD3UgDm1kdb427VqSjd5pPNjAj4WymmwRoc
	 1PnzNsT0PbuDIxPmnLwTVwucMrv7hLDM+PzcsOE/a6UIjFaTGpg7CSEgYMOzP82SEYJrD
	 PFOZyFxI8/Vxz0jSeFWISOcE1ro6+qvdjg6ilORj3opYdCB8X2ICq+6HWlfPudvCC8/x6
	 XjGKKzyWmbRy2WEZFrnqJf+DCDsFX1UIryf8+AXCRGCnjzhMMhOsOyMFbwJ/Ck6fLxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795786503;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ppTm8uD8R3ENsxrdlGkFMayFfue0bPBWIzSF3qL6OMg=;
	b=i1js336Ge8QeksH2BXORTUQfKcTFC9+RbqygeSGS/T5wfaM7cyEdm5wl384+AU2QljOv
	 39LPcy6wvssD0/xZUkR9s0ree0GISt0jhXEGTMlOaTdN/zggb1hPb/jhW6GJuN3XxlViM
	 hW6HMWIceANS+wr+VEt31KmxvzB3S/7bMjCV17ojXekS5lwnmqDZ+E7ulrrm9pgzoFH8w
	 6cabZ2yKQXRyW2Hqksj4u5HAZQOhOz+ZHA08DDVMWEETZfk3zfwukv7Kdc+cwXcR6Cl+f
	 CXsEsLNtwsguf1uyEWchZN+DM+9PdqB9GYZ/21vYEAhbCf1bEIeegCtgkAzdRTROTQg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V6kNTMcy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C2606A338
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 13:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 047C2606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V6kNTMcy
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5c1465bbbdaso6844420e87.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 05:35:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795786501; cv=none;
        d=google.com; s=arc-20260327;
        b=Ca/gwYJjEPHx0UrOJPrnPpEkhjPzSPA4dFwQeeTA6sLAFKXm03OObh/pKq/1+IN1nV
         Ry3f8GhKkNA+cCXruwEDilUO8lfoXjzO6QcMYoRWPllCW/DnGLaTQhVZlouPYKUu+tM+
         DB9Z/G24DrBU2oCDc/sW1cgkaxRaiouGyu0dCgPaPvvgACq4kF+XZRiSdPYukGL1kU1Z
         VZq3+eb4+ooaV7FYUpO+erUP1ob3l2JDk8ZqcE4KiTaRQYndG5QChMuJV8kqS/2HJCmV
         QaVS7OgAy2bnHrXFfQe5hATMmYqnGvEazl7wuZikuwK5XNeY9yliXg7RfvspxFmc6OSG
         ec+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ppTm8uD8R3ENsxrdlGkFMayFfue0bPBWIzSF3qL6OMg=;
        fh=Jfbb/HfBgfNCB97rIHJWGEa7KLxuaN6aUwdohP+BqT0=;
        b=JrqrnncqdZCHZRXmCcFdUQeYz3c9/qP1H2xf9Wv7w7rKFSWzbCUQXg+H1hIcgf3BE8
         hLFtsl7EW53wW/kHzdzEhWzvJLjdnbf14jOc1fP867iOt0swK5GwO/UEnrNHyGe0Y/TR
         pLq4zwJHO9f4MGaoZF52m4r8wjeeAOZfFPX2m/ksNaVklqeHw1ClxLr5vF7eVHyK/1FH
         lRT0UpMAargDhiyJP17hH2nD63G+KvK9tcj3h81hrX39eMg0SHcLIyibTWInV5QU7j0c
         MPH1x8XVtXRnlD+bKdvu4/zIx133++Uj37fuHtUXmsikvUDL8Qz40WNZ41RJ4Ixuk+3b
         cU4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795786501; x=1796391301; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ppTm8uD8R3ENsxrdlGkFMayFfue0bPBWIzSF3qL6OMg=;
        b=V6kNTMcy/zn+5F+AQnMMxLk1+xdDD23PPsqiU+xX+iXidRtFroqXKQikAwRB6iZ1/9
         WfO+VI/3MDBTe2eK5RLeE3+jbYOux0Ll6eJ5uPRlKmAwO+BxHNKZeLBiJ+6OA+sjMmyE
         NtWS5ZXTyg0OeJbXqRqCdbJciDOCbiouGie8EIQ8ylz+RqGMEOBWrHA6Pe3z1pMhLLDX
         BwsD7+gDH4RwaXWI0YH/P+cZjjDiKhydKl5nzu67JtgSL7Kswm9MPFfgcAUgerpLddae
         pRgm34lt8tXsMHTmLUezsQo081mtXYA0j4uYTIZ24HNfAnCyeBqhpHNnUl/6ZYCqxe5I
         Eh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795786501; x=1796391301;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ppTm8uD8R3ENsxrdlGkFMayFfue0bPBWIzSF3qL6OMg=;
        b=18SFWKx6z/G6DeDl0EgfgBePel9FVEtQGeqCJ/B6JjE4B/TJnPgzICDjC068DxhS40
         Di8XQGsUW5dlnSJT8NsnB/X8/kWZC8IHCT3YO4J8qR0vVpuTQO2WvtCg4xrlnD8A2hnZ
         gF+8J8cURJ6sFfPartEK89TIQ21ORTRlSoRwlM4JYc07a4q3yO9TsLAVnnXfT4A7GaR9
         yVzUm80GjwWHmudCW0zYmlMzwptLXcb0gyRUJIzKQOXL9x7PaMRkVU+bmzrLGRDFWLgL
         HMt9t9EWG0bDYMKRo7vQGI5CGwHlLN12iXJ//NTRq2IeHH4xXJoCcOh106b0cVWejlUF
         0cEg==
X-Gm-Message-State: APuU4Z+3bcLek05XTth3L0rtvkaqqmXTiZ4+qf3Q/5K2nWxf3q6UR+iI
	kamY4Z7tQzBac+Iza0fFbl+TdUzC4pNvNGvvRVaqAmdBc42kqk34x8j/nidBNW1c8yBOVwm+nCt
	UDK+owslE/hLTgf0V+lCl4e4AFfNkhM4=
X-Gm-Gg: AZFdTZfcqnTm1M9SPN6YNuGfepF7ozIbTx4fI/mlQmNiC/FHq2ISggv/OHO6NICQQCz
	5K46JbLJs44N1QFM6g7caB080InqLzMppjFXYx57TrgunHnGxZFqO7MPvhaaCsBW7aRlOVCOXdA
	yUaD5OvfEChP1+LvQEasJ5uuT7QVmn0ajLXF1RoONrGGbKp1LTx9jf0kfIqB3n4iCT1maBX7GVz
	6l5fCGIwRqWVkICsPl3LAAOT0H5NB0iLmeGS7D2M+eqxFAsnLxQjvCUsGOnKFwYVGwerMkgswiz
	9Tc7cxn3EUgi275D+0XctiVgEoA0x8h5F+SViEBclReRcCr6b2zeEEs8NAcbPglkWnGjfow71uA
	eRRLyJ96rhxjRSsGsISSlh6vTy5kdCNENNOc34DrwlOq+S+vMM/RXKF41K+XyzkVZwu8wColw7k
	jnHv0DFYvFwTxP1qgHCJU1eVKEWAcT79+z6rc+0VaSK08fMYgezM3eJJex+Mi41SyUIZGLhxRxT
	7OAxnxMD7ET4YXhaPfR6FMngv1tV+nRyGhVO0PENdrJVxT+f+FehfX2
X-Received: by 2002:a05:6512:a345:b0:5c3:23b9:9660 with SMTP id
 2adb3069b0e04-5c323b998b5mr2020693e87.18.1795786500844; Fri, 27 Nov 2026
 05:35:00 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795600611.git.zhudongjiang@fygo.io>
In-Reply-To: <cover.1795600611.git.zhudongjiang@fygo.io>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 27 Nov 2026 14:34:49 +0100
X-Gm-Features: Aa3M54pYlT0pZlTySJZd9VepC_yiXrAOjK_L1MssuG-BzYlD1GQx_Id11FQIQfk
Message-ID: <CAD=K2o9Pr8xBH_+ZYZM6vxCzaA_TVjHCd+oSLw+YsQ+qP5vHzw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] btrfs: zoned: fix active-zone accounting and transitions
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: linux-btrfs@vger.kernel.org, johannes.thumshirn@wdc.com, 
	naohiro.aota@wdc.com
Content-Type: text/plain; charset="UTF-8"

Hi Dongjiang,

I wanted to test v4 as well, but I couldn't find a tree it
applies to:

- the base commit 7bfc2c517eac is no longer in btrfs for-next
  (looks like it has been rebased since)
- on current btrfs for-next, patch 1/4 fails to apply in
  fs/btrfs/zoned.c
- same on your for-next (df5b88a7914e)

Could you push v4 to a branch, or tell me which base to use?

Thanks,
Jochen

Am Mi., 25. Nov. 2026 um 11:21 Uhr schrieb Dongjiang Zhu <zhudongjiang@fygo.io>:
>
> This series addresses active-zone accounting and block group
> transitions on zoned devices. It simplifies conventional-zone handling,
> restores metadata/system write roles at mount, and addresses a
> balance self-deadlock and a race during zone finishing.
>
> The four patches:
>
> 1. Track only sequential zones as active.
> 2. Restore the normal metadata and system write roles at mount,
>    keeping one active block group for each role and finishing the
>    remaining active non-data block groups.
> 3. Remove obsolete allocation-time non-data activation, leaving
>    activation and role switching to the writeback path.
> 4. Serialize concurrent finish operations on the same block group,
>    keeping it active until the device operations and active-list
>    cleanup complete.
>
> Jochen Philipp tested a rebased version of this series on his
> filesystem. He reported writing another 2.3 TB via rsync without
> Btrfs errors, a clean unmount, no errors from btrfs check --readonly,
> and a successful read-write mount afterwards. Many thanks to Jochen
> for the extensive testing.
>
> Changes in v4:
> - Rebased onto btrfs for-next at 7bfc2c517eac.
> - Retained the upstream active-zone bitmap check for mount-time
>   reservation accounting and the conditional reservation updates
>   during activation and finishing.
> - Moved abandoned-tail accounting into do_zone_finish(), alongside
>   the alloc_offset update, preserving read-only block group accounting.
> - Removed the unnecessary temporary block group references in
>   mount-time cleanup.
> - Updated the commit messages to reflect the current base and clarify
>   the role-recovery and zone-finishing behavior.
>
> Changes in v3:
> - Dropped the block-group flag comment changes from patch 1; no
>   functional changes.
>
> Changes in v2:
> - Removed the [BUG], [CAUSE] and [FIX] headings from the commit messages.
> - Added a helper for identifying zones that need active-zone tracking.
> - Added block group locking around alloc_offset and zone_unusable
>   accesses during mount recovery.
> - Explained why moving the active-bit clear alone does not serialize
>   concurrent zone finish operations.
>
> Previous versions:
> v3: https://lore.kernel.org/linux-btrfs/cover.1787887776.git.zhudongjiang@fygo.io/
> v2: https://lore.kernel.org/linux-btrfs/cover.1787717573.git.zhudongjiang@fygo.io/
> v1: https://lore.kernel.org/linux-btrfs/cover.1787551793.git.zhudongjiang@fygo.io/
>
> Dongjiang Zhu (4):
>   btrfs: zoned: track only sequential zones as active
>   btrfs: zoned: recover active non-data block group roles on mount
>   btrfs: zoned: remove obsolete non-data block group activation helper
>   btrfs: zoned: serialize zone finishing per block group
>
>  fs/btrfs/block-group.c |  38 ++------
>  fs/btrfs/block-group.h |   1 +
>  fs/btrfs/disk-io.c     |   7 +-
>  fs/btrfs/zoned.c       | 211 +++++++++++++++++++++++++++++------------
>  fs/btrfs/zoned.h       |   9 +-
>  5 files changed, 167 insertions(+), 99 deletions(-)
>
> --
> 2.39.5
