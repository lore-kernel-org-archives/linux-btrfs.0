Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794503505;
	b=Z+NxscsP9DLqJ+6mNzWwMFDEJGJXoIJXzZTZ4y3ukJWsUJY6TJzHCpChpjG2tYb+fxKb
	 sA0eFJObIywRp4MJmHuyp6MVkzq+/w/fY9bswY9AE2tnAUTtXbbZZJHO/oPtDViQmXOjb
	 eVVcIngJkm8jJWR4HBUenf2T51qtuss7nFn93xB5RswsVd4A6mJdzs1hWXVLJNdb3Ys6Q
	 0jdMzzXWNzd580zO5ZLfmrRNM24HA+TG9tvfJmkLvRtEevpJnFzARoykdoZOZSiO793C8
	 3wdWxIWY+sUF626RFG1K1QpXVa8GyjibzWJUgyN8j1symJHuPGw2Md6eOCIlZ6leroQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503505;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=QGM2cpFz0ONu2Q6+DFk5sCSFJML/TOmusE4o2JQDKh8=;
	b=pR4DhpnAhH573oVtHvCTOJEpwiduH+ZwB5vpPPmd8K36sT/wagjBO0mz1drGNhzrI22x
	 FN5x48liIy4BtTAuCzkVkTYdy4tSLksmcXqDN9XPDt52j8AcnC7gyVTq7UnH9UP5nh8Wh
	 Cepxxs17lbttSo9YnMhh/nSjBoVbhpz4BnN0JNF+fjBk5TW031Vo+rhZo+c33xr4TxKOr
	 qjC4scEmh7uiPAE/+B8O8jiyzuNNotocOpv/62Q0xbmfNYhAlSi8DWiHxlPGlPIlQw9dv
	 ZJAEt8f5j6jgSOpP+U82SMKEfIj+pPixGguuBRESim3OnfTm8XE2MMhwhglwtGhUmaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PBU3qQcP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.70
Received: from mail-lr2-f6.google.com (mail-lr2-f6.google.com [74.125.230.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A19606A330
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 17:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0A19606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PBU3qQcP
Received: by mail-lr2-f6.google.com with SMTP id 38308e7fff4ca-3ab1bfd1373so3479101fa.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 09:11:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794503503; cv=none;
        d=google.com; s=arc-20260327;
        b=RkVYjox12o8tsPq4osHh3T3EJPRpbHVloOhXMcQXyRbR/YW2fMJmq84B0WH5nj2TI4
         PjXJAyg7v4gdf8GsIpO4lKE5JLa9g9F4mFHfzuFBpIWyaV8WyB9KAk/xBkCPoqaJa8x/
         cKn74/U8wTHKZUlH2nmGqjMKLtTBK6YzHFDAz+X+kP6aayuGM2JhWuQhYbJDt3vd366s
         i2WGd+2ts+69fXamt9dQFcxsGDeU5gBraWpjfFilm/lsZrQ2TRYKytARctixojqTB6j0
         iV7+mmDayz8jE/ud1oJHF5GcYO9AGbCDQHU7h2ZXI5CxqWkfmHNL9jpyBo+dmPmJmnEz
         e58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QGM2cpFz0ONu2Q6+DFk5sCSFJML/TOmusE4o2JQDKh8=;
        fh=52HGdZoijDY46FnnDRkX1tDbZWbiUCWYGXtp7PBSqEk=;
        b=CZq0PaMnx1UDmujDaLscJQ7YIJKujLVR0LYPywVb9qpqLZIQ695LR1KjBk2j8iplcQ
         T1CBQwIvlKz7+SU5QxSUcD6zkL/qfEuCWrXZOF0v0DdbLQWGom7QOZGmHPuBRQ2mNdWc
         NX2Nsk7DD7Ma3T8RtRy9q3sbRL9M0vIyDQEqimrlSIhUswHqTaWt1o+24lbDPNKOLjhg
         CKCkwTAkJKS6qMgsSBJyqop0HIoGgQV/w1AWz7pTchIofSh2Q7BK0YpHkB9n9GjF5Agp
         Io2PC23gj7uhn6T6765bQans42xV64dXmupfRxbgxO963AlqJshmkWZjRSliHCI/Jq+T
         zk1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794503503; x=1795108303; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QGM2cpFz0ONu2Q6+DFk5sCSFJML/TOmusE4o2JQDKh8=;
        b=PBU3qQcPICdCX2BOC920SXPe/sSx0C2alUCGIt1HsS525PS2an9pkXG9/al6Xwv80Y
         nJkMbjAWY1z5bEjiVIPriF/4DTJem3DPM75erT/71g99DW9PuZQWD1hJC6jppblOvt2O
         HhrMq7KvY86NllFNPf+jBXudIKf4mZq+IkmYHsD81eQcjza3MVCK/8nj1qjUZAFlzcMO
         Ubgd9YEIBkw6Z0IEM2iDw61EV5FYo2hslC2IYI9LMWbPe5kKqs0z9Df8Tdqk7+jikgtB
         hFfEOZLpJ4XNYx9mG6u8QJq5YEAAXzNOTshUdqsVAnI6NABB/jQ43LUAYuOgkk4A9CJO
         lp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503503; x=1795108303;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QGM2cpFz0ONu2Q6+DFk5sCSFJML/TOmusE4o2JQDKh8=;
        b=CvpltwMEttEgJYwhpCKDibVfU+CWIbxevYgUDhI+0ZoUJUsjt5rb4NrbAs1GqZPtVp
         jJJTZDABvdFp74zt0hwyas2hNadRGESuTQQevtWdO296e1yNA3atZMsNZ5sjBdtH8BM9
         81Rw1n4RC7x6nEa6Bpw+GtD654PsLxEr8/Cm3ezGP4fArr+/o6lItYkmK73NfvhT+OtM
         jVvvgaKaajZx3hqHZxSCPp0ysFges/hkiwztYNXFhIOVlw/88qBDNDsouk6aUHU4EoLE
         1GABi5oK9viaEBD2pCbEctq8asHcvxK2QVeGiI39gYxrw4xHz4OPtZo0uhpb+mYRL5sn
         bkqQ==
X-Gm-Message-State: APuU4Z/LJv++5VX9RbbioxedzU3Ov1fLVEom91uvdshiTG1qPAcbtOd3
	P2vdI27xbWT0BBdI00tmW0Nw3dsNpsMsyKeCgHefc70evyE6BDkGuytxmte2IwGCBpVareG0sCV
	E9wHz9mUlZfIdujgEl7tK4kNlsknPMFZy1H1LEq9/XQ5v
X-Gm-Gg: AYBFou3qM6w9ZrvOvqrmhL2QDDwK9deENiJRuILGAizAJUBv+AlM5oErvHPcEQvs4zT
	OuFQ1wYhoKpGfrjOE3hNHLlybosNmL08hJ57wAobtjwP6uKKGbuKlW4YTvFJ7VIPcfnh5qmiOMu
	UJWZQYUQjVrV8sOm4zI/oV09DpPyoZLgULhmAt1YtJGd3/jcRFtFV9maJYgmJE6kFZYN27Yark8
	C4NDcMhpg8NYQewGdBuaY/r4Z1kmB/sNyOrON7ZR1NI2qntP+6cfYJ/xoNBJ/bYg5uFVapzflp7
	gj1fAKdPTI62eD5biOIUSFu/XRGMwAz5ARfpbR4PP4hw7QNsh5z88ehwWHz/H8B1wyq3FgPFsiZ
	D+ddW7iBrwD19DkJpz9ELB2hrzk6v9gKpbmuec3OZib/M4uYG02E82kvUeRSz1wJrMoK/
X-Received: by 2002:a2e:9a14:0:b0:3a9:87c0:7737 with SMTP id
 38308e7fff4ca-3ae2b524911mr639101fa.21.1794503502596; Thu, 12 Nov 2026
 09:11:42 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Fri, 13 Nov 2026 01:11:29 +0800
X-Gm-Features: AclHuK_uUOvBnl5Iir1Aop6fKG622tVucuN8UbTKKfWEXFSQatCBOfFt44PLafE
Message-ID: <CAO-4RZ2FQ5EaMV0H1016JZXzV_+57bro9=iwRmQtctR1s=fpsw@mail.gmail.com>
Subject: [BUG] btrfs: WARNING in btrfs_create_pending_block_groups
 (fs/btrfs/block-group.c:2929, v7.4-rc2)
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi David,

We observed a reproducible warning in btrfs_create_pending_block_groups()
while processing pending block groups on v7.4-rc2:

  BTRFS info (device loop5): balance: start -f -sstripes=0..7
  btrfs_abort_should_print_stack(__error)
  WARNING: fs/btrfs/block-group.c:2929 at
btrfs_create_pending_block_groups+0x1044/0x1810, CPU#3: syz.5.22/21682
  RIP: 0010:btrfs_create_pending_block_groups+0x1044/0x1810

The warning is generated by btrfs_abort_transaction(trans, ret) at
fs/btrfs/block-group.c:2929, which fired after insert_block_group_item()
returned an error during btrfs_create_pending_block_groups(). The
btrfs_abort_transaction macro (fs/btrfs/transaction.h) expands to a
WARN_ON(btrfs_abort_should_print_stack(__error)) on first abort. Our
guest runs with panic_on_warn=1, which escalates this warning to a
kernel panic. We have verified with faddr2line that
btrfs_create_pending_block_groups+0x1044/0x1810 maps to
fs/btrfs/block-group.c:2929 in the v7.4-rc2 source (no local
modifications to this file).

Kernel/config: 7.4.0-rc2-kernsight-kasan #1, built from v7.4-rc2 with
CONFIG_KASAN=y, CONFIG_BTRFS_FS=y, booted with oops=panic and
panic_on_warn=1.

Note: syzbot has an upstream report for the same function (open, with
a history of BTRFS: Transaction aborted (error -28) via
btrfs_inc_block_group_ro() and balance-related functions):

  https://syzkaller.appspot.com/bug?extid=c14787f64c14bb933980

Our crash also goes through btrfs_abort_transaction() in
btrfs_create_pending_block_groups(), but we have not confirmed whether
the error code and the calling context match the syzbot report. We are
reporting our independent reproduction on v7.4-rc2 as supplementary
evidence.

The crash depends on btrfs state built up by preceding operations. The
reproducer is a multi-program syzkaller execution log (63 programs):

  syz-execprog -procs=8 -threaded -repeat=0 -executor ./syz-executor
repro.kernsight.prog

The programs are replayed repeatedly with 8 parallel workers (-repeat=0);
the execution order is not guaranteed to be strictly serial. The balance
operation that triggers the abort is visible in the console just before
the warning.

In our fuzzing pipeline this reproducer was verified on a fresh VM
(reproducer pipeline outcome: confirmed=true, status=verified).

A full write-up, the reproducer and the crash artifacts are available at:

  https://github.com/Zheng-zheng-codes/btrfs-create-pending-block-groups-warning

Repository contents:
  - README.md                      full bug report: phenomenon, stack trace,
                                   mechanism status, reproduction steps
  - reproducer/repro.kernsight.prog
                                   pipeline-verified reproducer (63-program
                                   multi-program execution log)
  - reproducer/repro.prog          pipeline-extracted program; not a standalone
                                   reproducer
  - reproducer/repro.priming.prog  state-priming program set (pipeline recipe)
  - kernel.config                  kernel configuration used
  - environment.txt                kernel image info (sha256), QEMU command
                                   line, syzkaller commit, reproducer command
  - logs/log-*.txt, logs/report-*.txt
                                   original syzkaller execution logs and crash
                                   reports from the fuzzing pipeline
  - logs/machineInfo-*.txt, logs/title-stat.json
                                   guest environment info and title statistics

Happy to provide the kernel image, the crafted image, additional crash
instances or raw artifacts if useful.

Best regards,
Zheng Zheng
