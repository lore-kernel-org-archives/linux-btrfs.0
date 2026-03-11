Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F83D2FE0
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 09:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221262; cv=pass; b=M3O9BURQm3Ds9I8CX14JZ8C5xS8kWMdR/we5DVwFmkSFimVcZIXQ1A5gmoQRaOPXnOWPAzy8e95GPJ5DYicdCoW6jPafUFSC37F4ozA00/nzbT9FATt4/IT1q5Pd9Ej8XwLICVxQZx4TmrNHFAdP5UbqonfHeR/UlKStI5DGheA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221262; c=relaxed/simple;
	bh=0Sk9IgBaRP3/2Rrnn9kJRNjprchHpqhGnqSmPgT8ifY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=myHxdMU+4finOtXp1wRnS3gqfxPw+chAvIxnEE8Hp8kCkuh0lPXoKm7NPtLYlM0N51K2tdhWNqMlAZl6U77eRJQgux1gG8kKo3xhIWPtD+lzAojUd3fbwQijCmC7YL+V4Pok+zKg5SEays4me9CnGx1qdU5WDR1c+Ji5EBlft2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JB0oOZQN; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JB0oOZQN"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ae4d919f9bso63654715ad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 02:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773221255; cv=none;
        d=google.com; s=arc-20240605;
        b=TPCP8J0d0JDmUh4G+tQ3m3CFlIcyPWGKSJ3qSs7YoTSfNV/q6PDwj/JAKC6xY6R6jO
         H9i3bJE5nDiF6CFx+SddVA3OYm23PW+pz0USMnXTwsivWwO/nYFx25ZrS0H/1RFJ2TuA
         KOEu6FcNJnP0uJEqlK1Qvc95emX81txW3jS/t6/LexMPlJ3NncOaJCQVOtK60a6iNAOZ
         31wW/uGLTFOeakyFMD5vOBSHtxmo4hPUzEXm9eKYdelY4SepTybVX441w7AzeEPS75V7
         IBJaGr01kqSrqP/4RRJv54haA5MWgm28le9Veq4Qn5J4sdmcoGp/GvVewiF3Ze8hAU2V
         zYCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0FuBYPs7JMnez5s7bGejvUDHfv5Less9EspYC3sfJKk=;
        fh=Y3qOY9vms4ie3XiVCowdld77NqVFLP4+Tnd+UCoO99Q=;
        b=Els+9Djz7/jcHYTwdndXmopTBdCm8o9s3Iz0aSFnRdC2LqoLi3EX8TW3bDpZZXZ24l
         OnMPTMh/h3hgTLfwsmlicakdSVXZBVP+28EJ2jisXZY1I2SAMFyjBNDDNmHLlgMX8ZVA
         lg4YX3n2zy9zMZqE+gAu1Sa28nFjcoWouMkvRWDjEWJW4iC086/qmNpLZFRQQpNH7lTR
         2sghMC46Su6TIZ8vXX9zTx1ItTI6zBSnHiRSNEdm4QWgq6SOH7zwwFPbiGheNNLJRaBW
         MNIXbnqF/Xnf/19l7O3le8L8qzpj3GAexRMwoawrxYwlMtd2HOA/tFasWRHTeWKHgngo
         gXug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773221255; x=1773826055; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0FuBYPs7JMnez5s7bGejvUDHfv5Less9EspYC3sfJKk=;
        b=JB0oOZQNjrvQAzMT3jfAoPsQ5fV5x37RRg0ew+S+y1Ei8/gvtGD7jjkbsWuyAhEIWv
         LcXgD2EBHucE2Gnerv91Yt5iuq+/SPyJPZuoL2wvayXRpRJQ6WF4MG5o94jp1WD17qZv
         aJHWru4yzhtfej4zK64YiDA2kcS3xCOu1G61jqyoAseschnlwM2HvmmVllyDBIzRtCwi
         SLmVPuHQHUiHuL4YiztPjjay/RyqWZzryDo0InUYW6OEkOJr+RVORnvDe9JHmsgHQ4Jh
         F/5xkB/u2pCx/+/0TDpgQ6HtmGrzZ2u0tZQdQWgOHja8UMhMtXH0Cx7VBeThtxOPx7au
         xG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221255; x=1773826055;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FuBYPs7JMnez5s7bGejvUDHfv5Less9EspYC3sfJKk=;
        b=mTTSHn9uLw1a9JtFq4UGHLjjGrLtahpcl4MDC2Dg/6D38sqMYZASIrQRD+bQJOHakI
         sY9rE3Q0EgXcxLFw4iBdK2EldLvwroBd4n/SXdMLRLCRduw3NumA6zVdxHgA8VgPTrfh
         KD0GN/xNLsINY+6s6IG/R49721atN2qWLGB3lPGhAH2pjeOZf8F6WrQUqOUkOs09tYTM
         h3sbUJClUsr9ACqdxHwjQXhN/IXfGGS6nFFQOsfMkX1hvFk6+75hTcBAA7yeAFm0YRr3
         OPkxZKWIzB7KiRnF06tb4M6EzsSTkRQWyi0p8Den0Ztdf6A5vsyHQ8zCbTas+RxjmsGZ
         YZtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW97kbhCr0XY5s1LdM+cEAYwB72Tagl/8dXTEf2t9zLRRCehSGn4UAjf0iTwaTUFKYWAaqQuxKA5fSswg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTmesB9aTAkdDocXAXThwH2o1ELM6wLdp2XfifhxJpdRzDZSs1
	Yan2PEyqAQdmcGYBL3Gejz+Yhpd8iRBXaNjl6YHnun15FqePM06XJ7XHP2JphD/ZI+ujpBvAMTF
	Ugguwci6nXoMttBVWMGstvpmO8DUwFxU=
X-Gm-Gg: ATEYQzxvUPqYSFX+x3Gv1C7AUXa0osnZ75t8QHa7FyMcinBe5MbZb9kw6EcM11fKe8Q
	Gm1+ap2I4Dctf+7wlB1lOnpWX2ZHimi7o9143/BKJVN7EQDam6Vb+nCxg3E4tRQPuD+vvVzOUyd
	LMDS4z5ejvDw9Mh+AWCfgEeGHVZWMJudO3rgelV4c0zYPWvZFfHLA6n10e7IInP1S0TsU3YYyRz
	j0T9lkvJbklyCT9xjqQX6p9BJjjDJ4qTW334KgkUpnKqoL7PN9cNbTpu50wOn7904eBdXlz79zb
	F5Lb5W8=
X-Received: by 2002:a17:903:37ce:b0:2ae:5b64:12e3 with SMTP id
 d9443c01a7336-2aeae8a83f3mr23261485ad.41.1773221254583; Wed, 11 Mar 2026
 02:27:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Wed, 11 Mar 2026 17:27:23 +0800
X-Gm-Features: AaiRm50C1L78jmDCo58vwv1OHeemoEqCpr9e8doupmh7IZXfuHASnMcrYJpqwZQ
Message-ID: <CAPHJ_V++eKhA8gbTAHmqVBNfLE0KyDA8DSAJYwb9Gnyy9vFtBQ@mail.gmail.com>
Subject: [BUG] WARNING in btrfs_commit_transaction during balance/relocation
To: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a WARNING issue triggered by a syzkaller reproducer on
Linux 7.0.0-rc3.

The reproducer mounts a crafted Btrfs image and then issues
BTRFS_IOC_QGROUP_LIMIT on the mounted filesystem. The crash happens in the
Btrfs balance/relocation path, where the filesystem aborts a transaction
with error -28 and then hits a WARNING in btrfs_commit_transaction().

This seems to be related to ENOSPC handling in the Btrfs
balance/relocation path. The transaction gets aborted with error -28,
cleanup_transaction reports "No space left", and the filesystem is forced
read-only before btrfs_commit_transaction() emits the WARNING.

Reproducer:
C reproducer: pastebin.com/raw/SZTu4rBj
console output: pastebin.com/raw/AxuvZmnY
kernel config: pastebin.com/raw/uJh0PYV8

Kernel:
HEAD commit:1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
git tree: torvalds/linux
kernel version: 7.0.0-rc3 #1 PREEMPT(full) (QEMU Standard PC (Q35 + ICH9, 2009))

Crash log:
[  104.838103] ------------[ cut here ]------------
[  104.838841] BTRFS: Transaction aborted (error -28)
[  104.839649] WARNING: fs/btrfs/transaction.c:2045 at
btrfs_commit_transaction+0x26f0/0x4c40, CPU#1: repro/635
[  104.841814] CPU: 1 UID: 0 PID: 635 Comm: repro Tainted: G    B D
      N  7.0.0-rc3 #1 PREEMPT(lazy)
[  104.845630] RIP: 0010:btrfs_commit_transaction+0x26f3/0x4c40
[  104.859441] Call Trace:
[  104.863409]  prepare_to_relocate+0x39d/0x520
[  104.864140]  relocate_block_group+0x127/0xe20
[  104.868107]  btrfs_relocate_block_group+0x1692/0x5aa0
[  104.877674]  btrfs_relocate_chunk+0x135/0x950
[  104.879094]  btrfs_balance+0x2392/0x5d60
[  104.884685]  btrfs_ioctl_balance+0x3a4/0x700
[  104.885434]  btrfs_ioctl+0x1edc/0x64b0
[  104.898312]  __x64_sys_ioctl+0x197/0x220
[  104.960636] BTRFS: error (device loop2 state A) in
cleanup_transaction:2045: errno=-28 No space left
[  104.962986] BTRFS info (device loop2 state EA): forced readonly
[  104.966206] BTRFS info (device loop2 state EA): 1 enospc errors
during balance
[  104.969915] BTRFS info (device loop2 state EA): balance: ended with
status: -28

Thanks.
Zw Tang
