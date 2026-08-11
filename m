Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B93314D9
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428033; cv=pass; b=Tk3LQzlxAS8Z5M41XnUnApoYr7KF4ZzcDliLnD98qUOR6emyGo2YPqMHHLKY6ccimGyM7uZoY+Jctm4y6e6pEpdmUzXQQgr+ETMhuIc6EkOTiDvF/zZ5VglwK6hrdqeZnUKYyAmf0FJcCcjiu/YNUtc0ykejPAzjp4iPRh5K7DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428033; c=relaxed/simple;
	bh=cxcS20JWSa/RmgVBdAzWxeD6pk6TuI5nVWQ7ooXuiqc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=clnk5SNXWtLc7WY6RqeZ0SqfHHXZzrfAtDQM4lV6YjwNLktWAop95TDRUPQZyLMW6ZJq5Zh8mb7w31We2ILTCpjDA/2AV9MgJMD2rfJ8LlwCelQNIHHFwFtLV5XeMLVjszfsGktYJi+Qb/Qv28AH4ficsc40M1rbqfxJtbNDmog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jqmw8LM5; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jqmw8LM5"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-81ed2a06b9eso30183317b3.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 23:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786428030; cv=none;
        d=google.com; s=arc-20260327;
        b=sHa8OxPJ5Avlvw8Iksi800+Tw/9+nGe+Kmr6ctWYEuKXZlRsPq7+5NbxI4QC+2j5BQ
         kulYjaKokbWAh6cUn0B8uqbpMoBUrQVUDObWaBhHxhUyhEKcx5aL06KxHQ5xCwmiWUHw
         XCHDdx8k6vsgW4xFKHE1yzF/spfXLvVSpS8brZ8Jdm5vnaZSIWPH0AxmLbAPD0emy/Gy
         NzujudYhD/ImmLldiuciU+BYgyv+IFeI0lQqSvVvdojPEECBM/bOOAmypi3MmEqdA0fT
         7DI8CTn4yMCAK5jcrkgp5NWfNa21s1eoF7riV9uo+Rh+CcwZNUN0z1u1CjXpIF/+Er8M
         KPLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XBC3g2I/4vHPjJTj4ciOdLO6F+k5HLMvfi7GurgQ68g=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=efxlv7Z7tVqqofXqL/gZ0X3sM3d1tTjY8og6m3hS0VpW8JXziFmhzcm3HLzyjwGEwp
         b0QcHj3xvSAJlGJILXdPKYlyFAkUpZNlfJTluDkYo7tpQO5ZinRyNbHklKGYuXxw2Vcn
         YCw8fNwLfjhy5C5EBMYW58nhLMgPg4sgYRMoIscAiZKQCMs1psfYvKbbcnmfsBkaV7ay
         iJh3iQrdWia916siUevPiL1X8RbzEyQlR6xlbMevHEYYf7Or6lx0hImGju1pPFFWgov5
         dv4XJyh/kWZDcv93yr7vZE/mQJW73m3gPdga2X0dUSWAmIh2Onir/a9/edNNLKnFpJsy
         sxag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786428030; x=1787032830; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XBC3g2I/4vHPjJTj4ciOdLO6F+k5HLMvfi7GurgQ68g=;
        b=Jqmw8LM5E+jv6IqYgeYa+6MizhcMzNoEhPkGcgfR1g/ZzmvrNYqYJui6gn7b7jbpuT
         Mtc4CBaOzitZf/g1aJNjBgD8KoeCuyyPE2eyG5darPwNKeO/9SbTgiHa8Bfbj8OKgb9s
         u1+4E8jNSgvDdmaz6g9uKUsuX0vjLHMw+6hzy9S5HlGHsKCwZGBCr+wr+W7dBb5UgRws
         K7oSYT5hrMKn3f/WtHwmWgNAR7JE8kyIIEpFrOAC3o0Su+AAKFoji7mT42r4Bo2pQ2I6
         rePIjYr/RapNJXH3FDo7P/99FiesjNZBj9uj2F5HrV577K5gqRuXfJebOlYZFC0zO3ev
         1YoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786428030; x=1787032830;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBC3g2I/4vHPjJTj4ciOdLO6F+k5HLMvfi7GurgQ68g=;
        b=LJmCiGs3eiK4fGosz6r/N9KpYsXsC4cCWYsrW+qNeWKvhBPQPE/8SBSB8syuL1PQ2m
         L0sgwrOXIrbTfLx65IsuiRGCRNMSRsySQaKZrMql9sOpBxa9VG84CYU73P2XSa3rXgF6
         CZoIX4lcvDUgckM0pPuAjw+Ed2ASK2RpWrcHe64g/SHFtXlNQ8bNWJkjxI9h+fUgYUbR
         gjIpqbY6r1QRjTemHcn698CR2Xzy3cnpbW9sjyet90+zDg+fCH1yYcADgD02Y3i3Wen6
         MsLV1nfozF44F1jBKea8PFp5qI5+kJhAxccHlZvUOsp99V2lIXEafr4Yyrj1lXNpzlPp
         S6gg==
X-Gm-Message-State: AOJu0YwlSym5RYU5E0HyqfFbo9QvdzJnNQyQk36GTgvU0p906OV31gYT
	igtsyGSoHYoXsMCAneOEGfidJLR90xAb04wdMjDeBfKnBwFvwGLB20nJL1GzRvVZ3Y9I+uIeQGQ
	BVd+JaSESg2NX+n5TB8ds8fqqltRBqnmyqi4z9Ig=
X-Gm-Gg: AR+sD11wePoRhQrUZGOtzx3tXllzp4hbu3vHZAJR8sMZqvji7tVgxRNVNZC5m1TqaO3
	iUMs+HBoAcXre+QesXY3wIXt1rUFAtklqLQIss2k/cqB1WOai4NfdwNbjtu1JqTL054l3i3Rcgd
	nfu0SrXue3Yl//4oIsZR1w7zj+2aP4EzAdEQFMt9mW7en+vk2ypwRUa403XMboUMDRTJ1SG5nHv
	dtKa9A4uFWClLr7tqcjvqBUfhuIY92n6vSsveL8FOp1jhyX9PQ3OboBEgTadvdYjqYjoTecAD9c
	CIdD/XxM8bQuWZROADGRu7LyWoXjo36uKxJRUJDZ6Sv2
X-Received: by 2002:a05:690c:23c1:b0:81f:653a:fb41 with SMTP id
 00721157ae682-82f2996fb2dmr5122197b3.10.1786428030476; Mon, 10 Aug 2026
 23:00:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alex Writing <alex.writing.things@gmail.com>
Date: Tue, 11 Aug 2026 02:00:31 -0400
X-Gm-Features: AUfX_myLUYasAYUrahw48kddUKyLxAjE2njvVQYXURUsu7kAUBdHMHVtVZ7EE5A
Message-ID: <CAD0nGLtyhz=M-97M4YowUpGpt+b5OBhD9fJZCx3e1hU1JYXemg@mail.gmail.com>
Subject: Space cache rebuild failed and reports fs corrupted
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, I just updated from Proxmox 8 to Proxmox 9, which updates from
Debian 12 to Debian 13. The new kernel is a Proxmox-specific build of
7.0.14. btrfs-progs version is the latest version Proxmox provides,
6.14.

After the update, my btrfs RAID1 HDD array failed to mount
automatically at boot because it was timing out; it now takes 90-120
seconds to mount the array for some reason. I turned on debugging and
there are lots of lines like this during the delay:

[Mon Aug 10 17:47:28 2026] BTRFS debug (device sdb1):
btrfs_submit_dev_bio: rw 0 0x1000, sector=1924895456, dev=8388625
(/dev/sdb1 id 2), size=16384
[Mon Aug 10 17:47:28 2026] BTRFS debug (device sdb1):
btrfs_submit_dev_bio: rw 0 0x1000, sector=5154454848, dev=8388625
(/dev/sdb1 id 2), size=16384

I read something online that suggested clearing the space cache. I
tried that, which ran for about 15 minutes but then failed:

[Mon Aug 10 18:12:58 2026] BTRFS: Transaction aborted (error -117)
[Mon Aug 10 18:12:58 2026] BTRFS: error (device sdb1 state A) in
__btrfs_free_extent:3419: errno=-117 Filesystem corrupted
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA): leaf
27083447287808 gen 1236591 total ptrs 184 free space 5089 owner 2
[Mon Aug 10 18:12:58 2026]      item 0 key (27083429871616
METADATA_ITEM 0) itemoff 16250 itemsize 33
[Mon Aug 10 18:12:58 2026]              extent refs 1 gen 1182260 flags 2
[Mon Aug 10 18:12:58 2026]              ref#0: tree block backref root 2
[...]
[Mon Aug 10 18:12:58 2026]      item 183 key (27083432984576
METADATA_ITEM 0) itemoff 9689 itemsize 33
[Mon Aug 10 18:12:58 2026]              extent refs 1 gen 1219190 flags 258
[Mon Aug 10 18:12:58 2026]              ref#0: shared block backref
parent 27105592623104
[Mon Aug 10 18:12:58 2026] BTRFS critical (device sdb1 state EA):
unable to find ref byte nr 27083430166528 parent 0 root 10 owner 1
offset 0 slot 18
[Mon Aug 10 18:12:58 2026] BTRFS error (device sdb1 state EA): failed
to run delayed ref for logical 27083430166528 num_bytes 16384 type 176
action 2 ref_mod 1: -2
[Mon Aug 10 18:12:58 2026] BTRFS: error (device sdb1 state EA) in
btrfs_run_delayed_refs:2247: errno=-2 No such entry
[Mon Aug 10 18:12:58 2026] BTRFS warning (device sdb1 state EA):
failed to rebuild free space tree: -2
[Mon Aug 10 18:12:58 2026] BTRFS error (device sdb1 state EA): commit
super block returned -30
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
space_info METADATA (sub-group id 0) has 867155968 free, is not full
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
space_info total=34359738368, used=33472987136, pinned=0,
reserved=3637248, may_use=15892480, readonly=65536 zone_unusable=0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
global_block_rsv: size 0 reserved 0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
trans_block_rsv: size 0 reserved 0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
chunk_block_rsv: size 0 reserved 0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
remap_block_rsv: size 0 reserved 0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
delayed_block_rsv: size 0 reserved 0
[Mon Aug 10 18:12:58 2026] BTRFS info (device sdb1 state EA):
delayed_refs_rsv: size 249036800 reserved 15892480
[Mon Aug 10 18:12:58 2026] BTRFS error (device sdb1 state EA):
open_ctree failed: -2

Full output here: https://pastebin.com/aMeu1XR0

Here's what the array looks like:

Overall:
    Device size:                  61.85TiB
    Device allocated:             33.13TiB
    Device unallocated:           28.72TiB
    Device missing:                  0.00B
    Device slack:                 10.50KiB
    Used:                         33.12TiB
    Free (estimated):             14.36TiB      (min: 14.36TiB)
    Free (statfs, df):             5.35TiB
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)
    Multiple profiles:                  no

             Data     Metadata System
Id Path      RAID1    RAID1    RAID1    Unallocated Total    Slack
-- --------- -------- -------- -------- ----------- -------- --------
 2 /dev/sdb1  8.77TiB 32.00GiB 32.00MiB     3.94TiB 12.73TiB  3.50KiB
 3 /dev/sdd1 11.06TiB        -        -     1.67TiB 12.73TiB  3.50KiB
 4 /dev/sde1 11.32TiB        -        -     1.41TiB 12.73TiB  3.50KiB
 5 /dev/sda1  1.92TiB 32.00GiB 32.00MiB    21.70TiB 23.65TiB        -
-- --------- -------- -------- -------- ----------- -------- --------
   Total     16.53TiB 32.00GiB 32.00MiB    28.72TiB 61.85TiB 10.50KiB
   Used      16.53TiB 31.17GiB  3.38MiB

btrfs check reports "errors found in extent allocation tree or chunk
allocation" in the checking extents phase (mostly root 10 but a few in
root 1 and root 4), and in the "checking free space tree" phase
reports "could not load free space tree: No such file or directory"
which makes sense since the space tree rebuild failed. It doesn't
report any issues in any other phase.

Here's the full btrfs check output: https://pastebin.com/XZFHLLvd

The logs show that one of the drives dropped out briefly during the
btrfs check, so I'm guessing there may be a flaky cable or SATA port
that might be the root cause of the issue. I'll also probably run a
memtest before doing much more to it.

The filesystem mounts in readonly mode and all the data seems intact,
at least at first glance.

What's the best way to try to fix this? Since I can read the data I
could always copy it all off and recreate the array from scratch, but
if there's a safe way to repair things that wouldn't involve finding
that much free disk space that would be ideal.

Thanks!
