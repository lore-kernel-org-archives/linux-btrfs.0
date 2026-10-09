Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B471F4F4757
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569497; cv=pass; b=Rkn62w8AqcKxIKvytQyOmjWBTPQZB4In/vZPYphfKelJwQkQEmw7JTQWmj/70AHPhvG82uStPfixY27ZCAvpyXal29uBttWEopuGp1tSg1rCO6hklSD6G1fhjRBzIwJPclAyyxi3beg4+cnFZqsx22CnCMIc14oZIJGQmKgExgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569497; c=relaxed/simple;
	bh=WdgR+YdkAuXsXE819GZyZO+BI0w8tx59DEQncF9OA9k=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MGcScH8SnMpg95vbjhjZeVgyP0yqLsfZajhrZldRPVI0PmTDZIk3KDGTpSIUYYapSYEUOqpEozpJR3dL1D8LfNU4TACVubnqg/Aeu1utb6E+N/EDWKlvTqk0LRW9W7tLqDG6qlZryqZLj8/SHceSafuUPg8kQ/Jl30nyZMNrj7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=niVwiD98; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="niVwiD98"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e3846d1caso22136566b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2026 11:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791569494; cv=none;
        d=google.com; s=arc-20260327;
        b=kjk7zEwY1sv4T/+yQ1YcK0MRn6Lq4Vp4DHc3eKOcId6+HyV2E9oattjNYvCt3nRAj0
         FQMeUgRJKv9w26ibKdTPItpiFD09gqzhQsBPoo9B3XwQN4au+py6oxrXo+6mXmEdmQAa
         3Nz/A2R1jX/tZmSlRPgs/cGbNe+tMwGgWnswZwIp4RyOPCXmNi9s2Vhon4BBbk3Vx3rg
         10oUrhhWxWjirxSrKG06B7tELfVyImA7QyHLh/Wz8vZ9h6Zmu+K5a+vcjQgLQH7I1Uk3
         d4ac+rVRoycpUO6lT/w2OphL6xzR5Ky/gZ+wIYNu+OKojVc6bDpPPf+Sb59/S08jsGtj
         jROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=No4eTPnZ+UxSBkx9itGIleDNkZefe+ociK7F/sLwaY8=;
        fh=92U4gh6LrZn3BiHx9NGlfz0aTFjBmOAljSXWsJlgNhY=;
        b=r8MsCcj3opQtDTBqPWU4D1JkH4QIbaPYLNvhFHYBffGoYygD1Qb18mcdqWCaJUef+z
         U7+cXLksU8ON3uWBmd1nwO/P1A8kIIO6Gd77k7G+/GU6FQ0oc9ComJrjzdbuLlnNwWZr
         JfuSmVHm+/2M5TN0crkhUrMdXYZk8qbnPdCegVeAWbNjU4AURRow/6finjOzzIWjwY6M
         9J8R/jyaCi5onhewz/oFYiGne6t+a4KXZFxworJ0KP9mmSY1yEb9GhSQvFjkDQV/uJoQ
         J+4+CKLuNiIdOKYR7CvGozQWOkuBz6XNyqR+HhE9hiHLPLkqjKAARUdci76yMLOJYuDG
         CC2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791569494; x=1792174294; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=No4eTPnZ+UxSBkx9itGIleDNkZefe+ociK7F/sLwaY8=;
        b=niVwiD983ijfQTRnbPRs491GCpGejDQAOYrLPckPNIGVkkddbx2SNAaygEavlXGek1
         NIElaMdBCHwyymuNSslzZbuhlGLHdtQFFGflTNft2ZgOCQzVPiIPEz/rAT6GA7mi6Abt
         g7AzXqt8gy3DNjfy3HdXGlEFX9nS2+8ViSXPtbYjjQDaACXFsuKPVE5XkrAIkMJg7WH9
         bZFN9J5yxoc2gQOS7H8mju7+vdSv/9xVBGG4oQxS8b11ku6I9Q3eiS5nkqy5yNBnrXEV
         35j7pz20xRXY23YM8WOoLgoyQM5jVQCCgL47kO5mjjJsOzlctzANSyFCPf/NEq6A1xWX
         WkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791569494; x=1792174294;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=No4eTPnZ+UxSBkx9itGIleDNkZefe+ociK7F/sLwaY8=;
        b=LXE1jHASpDu021q9BqUUIJJnudWgCVB+52eA0T1QZMsAerMhOka9xlfKK917R7Ir3F
         T/jyjYYapyzGK3CsKvC7h28KGa6YtXviVLfovEGg1jJRPp7ivYMf6zaslAjj9R2oiIFC
         vO5CUywc8BfQh8dvjmVInlntvio48wEtm0kGQNessrQXo8j18BMbGrWeGtj8YTzU1s+p
         8pL+4hqHvnaqFZSqqbiMyiaSRa+vST56Jp+NZ577QEa3WOcFeaeaQrD1gWAZDWJ6aXhW
         TZ5CS1jVz7YFlxDR9gSRNmAzBwWSR2GjNDsNCHxobJ9kXGzbt9BYxsRlP7eoGttrDlRY
         EMZw==
X-Gm-Message-State: AFq9FYK7d4ZKGSh2SDRVZ8T8MOJAoyOR01jNUEwpjL2m9Eq5fi+Kw10a
	rQVg2fUzvldVDIbmkKuBWbocIW+tSOTlKy6cbAEUCqJiZmxqMFQQvAjvlgYzKONRTxXcUmOwXJ+
	vGO3MDlwkhVT0uRQEoEMjDrbt2fPV5+SICRXS
X-Gm-Gg: AYBFou2tTBdxc80NPq6lzbl7mfAgyLTqx0sWS7DAkz/5KCLppQMG94cbbitRYl++WlL
	m1OSRzrZRuZ2JyAw2r/L7FSUrR3TRrWGXUU+1V5nboaHhV/ioy2QF+t2fgKL1gmzkKZlttxBdBd
	v17rNcFvu+YceM09vnoLKfKuppNq3eFWJCkHTlQtG76Cst0PiDtHBH66QdBbE1qDcvDXXb5zPkx
	8Q4l0l2qNTH6Fp2rVVZe/uMzWvO+Jv6ZrmCqYLzirGGGL3eto6LR5Z74ElxCsW02cuS9WorS4sO
	zkjG7bpWv+FSEnSSsTnhf4lXAxvSP6FF5NBpv4j9OXLSa6GdwnbhhxasYdsBjsCaV9Ik2KdPP7Y
	unkw20KcaZq1BVdFjk/BFJfL5xngYJwLtPxhs8B2k
X-Received: by 2002:a17:907:bb49:b0:c29:62d8:68af with SMTP id
 a640c23a62f3a-c31a9ffda78mr277596866b.47.1791569493771; Fri, 09 Oct 2026
 11:11:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?Um9nZXIgQWxhc8Og?= <vonbloom@gmail.com>
Date: Fri, 9 Oct 2026 20:11:22 +0200
X-Gm-Features: AclHuK_0U45sdGLsb4_JlQaS2HixZO7FmF0_k12UyuRozwqXHB_NNtmWhZpkzdQ
Message-ID: <CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com>
Subject: [REGRESSION] btrfs: fs-verity "FILE CORRUPTED" on readahead of
 compressed extents since 7.2
To: linux-btrfs@vger.kernel.org
Cc: fsverity@lists.linux.dev, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

(Resent with a subject line: the first copy went out without one,
sorry for the noise.)

Since 7.2, reading an fs-verity file on btrfs mounted with
compress=zstd:1 logs "FILE CORRUPTED" for compressed extents read
through readahead, although every read succeeds:

  fs-verity (vda3, inode 58996): FILE CORRUPTED! pos=8912896,
  level=-1, want_hash=sha512:...

(one line in dmesg, wrapped here). The positions are mostly multiples
of 128 KiB. read() returns no error and the data is correct: the
synchronous re-read passes verification. We hit it with composefs
(bootc) objects on the root filesystem of a laptop, and reproduced it
on a second machine and in a VM.

Reproducer (root, any btrfs mounted with compress=zstd:1):

  cd /mnt/btrfs-zstd
  find /usr/lib -maxdepth 1 -name '*.so*' -size +500k -print0 |
    xargs -0 cat | head -c 60M > f
  sync
  fsverity enable --hash-alg=sha512 f
  echo 3 > /proc/sys/vm/drop_caches
  cat f > /dev/null
  dmesg | grep -c 'FILE CORRUPTED'     # 10 here

Same data with chattr +m before writing (uncompressed): no messages.
Reading with POSIX_FADV_RANDOM: no messages.

Tested on Arch Linux's kernels (no out-of-tree patches) in a KVM
guest, virtio disk:

- bad: 7.2.2-arch1, 7.2.7-arch1, 7.2.9-arch1
- good: 7.1.11-arch1, 7.0.14-arch1, 6.18.55-lts

Also on bare metal (two NVMe laptops, Intel and AMD) with
7.2.9-cachyos. A similar symptom in 6.16.8 was fixed by "btrfs: fix
incorrect readahead expansion length" (Oct 2025).

#regzbot introduced: v7.1..v7.2.2

I can test patches.

Roger
