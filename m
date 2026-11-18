Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.193
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795005439;
	b=nFsdve666HP7mynPkTCHZHHsYfCaSYjWgd/E6f9RQ/Ido29BpP2zNjVhxi82bRBSG+6K
	 yctB/Ca9p1bMeJ9ui20UBe5LlJ/xMG8w+e1wbnpfVdp1lDblx9Mkvgj6mgAdT6RW9oJEp
	 pX5lxX2C7Ze6GN7w+hS4zwQADMxotmIqlE9fuhLjqfWe2G0FWbs/Ta5MABBfvbfl2Xuun
	 o/BMoBFkPEiWxo6LtsMZMTFs5DpYIsB7ZHXMOjyb6C0Qu2UH9r+/Fy9SPmFnWA8oNLhYY
	 bJ57O488iRLsonTLURo5i6E8S8QuRuCBYRFzDQmwuhWDT8iAsNER9ZVS7YMbEcKrglg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ULKfBiyPUodGwChJ6W1HqXCemItu/hB9DisezQMSBXg=;
	b=KVeDX3+jwhfXH+paJeT9bptYTTXskJmDzjN28hpQL2MWoY2Ig+DSaqjP/JEFTvfoxa0u
	 U1NEbvjDLDAWqJa2af+zUHlO6UZPJwsMITVgUGGZPEynPUIYQm89hEVzYumR55axx5/+N
	 1WMoKVcjqcXqDZCGuEv+H/Zu14O5pQ/OutXn3+QNqJsnuVq7PnEk/eq+zu7Zjz0O7vFp5
	 v90s0RScHdKqaXS0vLmrVdKbTVnMyCf2rraTD2jXkRuV670FzuqnDjwQ6tvgJzbNba9VM
	 gNujjhyRbcyjB1YnBn7TMSW6p3l+zGFN2yAtm6L9VR6CY4MxPqDBc/nQNgwCuiPhEjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dVJtkTPx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.193
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5067E606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5067E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dVJtkTPx
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-3adff684a52so8517401fa.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 04:37:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795005437; cv=none;
        d=google.com; s=arc-20260327;
        b=VUJJ2LVPvUWkTESAwQL5OZuSdPOuBSrGSn5MH7T82JOh/qvBfAOhsFk97RHCYFNNrp
         5i12dhh3kKinn0ZHmwnUAX3C6U/SXuXbx3QBw55KpLL+VfDEFZN8cRQBxW79pWwsVncY
         YKE/HYDI64fofrwyaXAPGmloLh0C4EH8RtnGULkQMgv9ncqVpJ8DpQNWbjrpG+zhg1rh
         ne4aLILJioPvE3iBbDdvm8Rw/fdkfbNVVjGIwN7+Khq1JZ3UW3aQV2lvogiTPayX5P0z
         a3Hv0bcqsZGGK7kQs3gTJL4E7pfd998a83g/K1PnFv2CrOfIiM2QFHt9etcGX70Cr1SW
         +jOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ULKfBiyPUodGwChJ6W1HqXCemItu/hB9DisezQMSBXg=;
        fh=Kyzv3hM1Fm/xnYL6tYsrvyk1IQWfwul4ojOW+lc237o=;
        b=OVTjQnpka3dUKYS92AU/Amc2pJbmmK+mu5mC2HivwLIlNmcLd6YxjSAIqoReu/DMjY
         Rt6KH/ap1UbdKc5Mrm7l8ZXRFQMVIQxvjItN08GjrLKVn1NVacRQXVGKpGC75KmL+wad
         w8zgqKhdwJWJFyXOaojmWyMcmAiC9JRkz2p+qcCMvi2mHXIrwA11TMZ4NWYnH9dbifNm
         2OugPlVllmKcHEvUDQ2mObNiVp/g0mrXWaykCjNEo7HUmRoR5KmsKGkva1+9ZrjktWua
         9uluTRNA0W/HtpoiMx1ol75kIp+fTC1lEVSDSDtVOBuZTQa9emdcCZ41oteE7lNcjNS3
         fvXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795005437; x=1795610237; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ULKfBiyPUodGwChJ6W1HqXCemItu/hB9DisezQMSBXg=;
        b=dVJtkTPx7SFaGLYaTzOJgPTPGvqndDUB7dzBI93C6wfJ7/MnKUPhLC8M37JUzYEdrv
         hhG8X9S2FUfxbEswDSEua4qpBHz4DzNwbvV4CrDaMw4uJ+D8DGQihtN8BwBQ91jXzgEr
         D4eJu4rBohLdR2VF0z3EnGSe6OyX+2PvoY06CGRQXzQyOalttjtAahTExs5a6D7Uw38K
         O6OFflqCjejEiqlwjP1h/rw10gNwHO1ZyuKlMyLWn83sRWMI6r/RnAUn2WOU+vWyeXQ6
         MLx4ScAI/8OeRb4bthsSfkHWsJJnpvCLdZBeQ9VHC6PAOU92/3gI7fpobLMH0HOppzuo
         PugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005437; x=1795610237;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ULKfBiyPUodGwChJ6W1HqXCemItu/hB9DisezQMSBXg=;
        b=vKhNxhry5XDBn8xTZEOX5Or7Ods1cf/l2kAkg8wbQPoyVW81d443n8fLiYnqQVhl7W
         6n1s2Nd667UDiwv38N0fCpMu/0DbweVIccl+LLLCTH+GtC3kl8iLeGtTx8jbPeEHt0ym
         OckKH1I/yUmdmAul5iyKwl2vGkBuslx4VmnujwW0NTobToBJbR4GZiZSm3NcWfAsuacd
         XsZLJ78ayWIUoMHh0eBlvrzTjvtMHLBWEd5S+CQB1pGGOwGw90yV0M5bqflN+KHEFzn1
         QO6Wi+XN7P6ZOGlkVwH00duarnEoQds4PClqW+WMEfk/czkJlY3VoKws5hVIP4IPuKRu
         W/5Q==
X-Forwarded-Encrypted: i=1; AL+hErEXuKa95UPun3wR5feUBEHabBvOO51dw/DB9qe779Jpcjt8TZL+Yd5d6NzdlIxC/Sa7HKoPTRcKCXj7cA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8Hy3x/H1lXwwmKJW5bmsTny+U4+d+letsMGgRanDvCEYeFX1q9
	Wy1hcaXaJWKf8jwm/RsrBhd9z16Z3n9Gu2NIkm1Y2Z1cS2NiyuMG80XMoZxL+iQ52NF4kLFhIUy
	dw5SaxFakLGk/dVwQYNSVTHNt907uksE=
X-Gm-Gg: AYBFou33NZ8lLU5uXZcOGz8RH/w9Y//MckMr9yB9ZiBiN4Y+E9qDab4IoulN1de70bo
	UwJiLUtIl9ThfqJ/i9ieJX4fSzkCzPHhiyIr0DjwRQ6Nkt7q0M3RfI/VLczzGHBCbHNFqij3FPo
	ny58wCtbQwQnznLyCxcTMO4jXfFPvj/UVZon2n69nwSV4Adwukwbx3gGhwt4ojT5PwFHnTPszmM
	9UywtKTXbVZOzx5fF8dsmPBF2bz7G6iMjwuYK/b/hh7vbfjRAdkj4qpGDV5b2h+iFGELcaetxTP
	Zhvmk+77u9HLvkMDYqYAZuxn7RzeJnRZ8ekxAAfULRldYjeMd8lqyJofUIjYYrqLiHwtmlXMnhb
	3Di6Qkx/KHweYMtFlC4lJMA2novD7I5o2EzHs250Gzl1U8nwdz9lOyve5JfUg9yaOMSJQS0Gp2k
	eNuW5gGjHh7uQZ6yg=
X-Received: by 2002:a05:651c:a14c:b0:3ae:c43:d892 with SMTP id
 38308e7fff4ca-3ae5c91dd47mr17035981fa.1.1795005437159; Wed, 18 Nov 2026
 04:37:17 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Zheng Zheng <fengaojigui88@gmail.com>
Date: Wed, 18 Nov 2026 20:37:03 +0800
X-Gm-Features: AclHuK882m7RkIPXulNkPGmJF5W6vqJWzBXr7PYXZHgIM8IyUvzbKABo3YeYs70
Message-ID: <CAO-4RZ1DiPS2+=3WPxRGSEajO=dnsfYi4zDyjcVp3LBy2670AQ@mail.gmail.com>
Subject: [BUG] WARNING in kernfs_remove_by_name_ns (fs/kernfs/dir.c:1784, v7.4-rc3)
To: dsterba@suse.com, mason@kernel.org
Cc: gregkh@linuxfoundation.org, tj@kernel.org, linux-btrfs@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi David, Chris, Greg, Tejun,

We found a reproducible WARNING in the kernfs/sysfs removal path on
v7.4-rc3 with syzkaller. It is triggered while enabling Btrfs quotas and is
stable on fresh VMs.

The archive and reproducer are here:

  https://github.com/Zheng-zheng-codes/kernfs-remove-by-name-ns-warning
  commit 1d8c9a81d3f812c9ea320afba737bb4be8643ed4

Warning
-------

The warning is preceded by a kobject allocation failure for the Btrfs
`qgroups` sysfs kobject:

  kobject: kobject_add_internal failed for qgroups (error: -12 parent:
d1a4d035-71e5-4764-8138-3b7234c5bdf5)
  ------------[ cut here ]------------
  kernfs: can not remove 'enabled', no directory
  WARNING: fs/kernfs/dir.c:1784 at
kernfs_remove_by_name_ns+0x10b/0x120 fs/kernfs/dir.c:1784, CPU#1:
syz.7.1656/40887
  Modules linked in: crc32c_cryptoapi(E) cifs(E) smbdirect(E)
rdma_cm(E) iw_cm(E) ib_cm(E) nbd(E) ext2(E) smc(E) ib_core(E)
dm_multipath(E)
  CPU: 1 UID: 0 PID: 40887 Comm: syz.7.1656 Tainted: G            EL
   7.4.0-rc3-kernsight-kasan #1 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
04/01/2014
  RIP: 0010:kernfs_remove_by_name_ns+0x10e/0x120 fs/kernfs/dir.c:1784
  RSP: 0018:ffa00000064479c0 EFLAGS: 00010293
  Call Trace:
   <TASK>
   kernfs_remove_by_name include/linux/kernfs.h:644 [inline]
   remove_files+0x9b/0x1c0 fs/sysfs/group.c:28
   sysfs_remove_group+0x90/0x1b0 fs/sysfs/group.c:328
   sysfs_remove_groups fs/sysfs/group.c:352 [inline]
   sysfs_remove_groups+0x65/0xb0 fs/sysfs/group.c:344
   __kobject_del+0x89/0x220 lib/kobject.c:595
   kobject_del lib/kobject.c:627 [inline]
   kobject_del+0x40/0x60 lib/kobject.c:619
   btrfs_sysfs_del_qgroups+0x156/0x230 fs/btrfs/sysfs.c:2463
   btrfs_sysfs_add_qgroups+0x1c2/0x230 fs/btrfs/sysfs.c:2502
   btrfs_quota_enable+0x2e7/0x1ce0 fs/btrfs/qgroup.c:1034
   btrfs_ioctl_quota_ctl fs/btrfs/ioctl.c:3605 [inline]
   btrfs_ioctl+0x46d4/0x5e10 fs/btrfs/ioctl.c:5663
   __x64_sys_ioctl+0x194/0x210 fs/ioctl.c:584
   do_syscall_64+0x132/0x7c0 arch/x86/entry/syscall_64.c:89
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Important annotations
--------------------

- The first line is the Btrfs qgroups kobject add failure with `-ENOMEM`
  (`error: -12`). This `-ENOMEM` is triggered by the reproducer's `failslab`
  fault injection, not by a real memory shortage. The warning is then emitted
  from the cleanup path trying to remove the `enabled` file from a sysfs group
  that was never fully created.
- The call path is:
  `BTRFS_IOC_QUOTA_CTL` -> `btrfs_quota_enable()` ->
  `btrfs_sysfs_add_qgroups()` -> `btrfs_sysfs_del_qgroups()` ->
  `sysfs_remove_groups()` -> `remove_files()` -> `kernfs_remove_by_name()`.
- `kernfs_remove_by_name_ns()` warns when the target node cannot be found;
  here it cannot find `enabled` under the qgroups directory.
- The warning becomes a panic because the test kernel boots with
  `panic_on_warn=1`. This may be a cleanup-path warning after an injected
  allocation failure rather than memory corruption; we have not confirmed a
  root cause or a fix.
- The warning is user-triggerable through Btrfs quota control, but we are not
  claiming it is a security issue.

How to reproduce
----------------

The recipe reproduces on a fresh, unmodified VM; no state snapshot is needed.

  git clone https://github.com/Zheng-zheng-codes/kernfs-remove-by-name-ns-warning
  cd kernfs-remove-by-name-ns-warning

  # boot the v7.4-rc3 kernel with the supplied config and guest image

  # in the guest, as root:
  syz-execprog -procs=8 -threaded -repeat=0 \
      -executor ./syz-executor reproducer/repro.kernsight.prog

`-repeat=0` repeats until the warning fires; the external runs hit in 43 s
and 45 s. The recipe has 76 entries (75 replay programs followed by the
testcase).

Verification:

- Main Kernsight pipeline: `confirmed=true`, `status=verified`,
  2026-11-18T05:11:34Z, 75 replay programs, fresh-VM 2/2.
- Independent external fresh-VM verification: 2/2, target hit after 43 s and
  45 s; serial logs are in `external-verify/serial-1.log` and
  `external-verify/serial-2.log`.
- C reproducer: not generated; the syzkaller recipe is the primary
  reproducer.

Kernel/guest details:

  kernel: v7.4-rc3, bzImage sha256
    0c16409f8aec508ac44a63e631c2bd352536401f3fd0856df1d839fb953a1882
  guest: Debian trixie x86_64, 6 GiB RAM, 4 vCPU, QEMU/KVM
  boot: oops=panic panic_on_warn=1
  config: CONFIG_KASAN=y, CONFIG_PROVE_LOCKING=y, CONFIG_BTRFS_FS=y

Thanks,
Zheng
