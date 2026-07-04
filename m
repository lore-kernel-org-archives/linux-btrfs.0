Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372AA3AEF57
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jul 2026 12:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783168353; cv=none; b=tD7POY6ubDdNnwYOowI7BIrQJEt2Q3BLGF18I2F2u/KeE5VoOvbe0AaMfO82C/uD1XAz++5Ic86chjm/INYF9YOGcEZoQDxv2adjdgtP+hEM5bKNJzPmSALPX5gUK6oU9GVtCdY1AKM5e0ENgBrK4zy5TzuLZcou5W9ForpydBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783168353; c=relaxed/simple;
	bh=6bkXxoQ0MUAAybl4GWHMrj/sIH/xfFP2gv6NzTyNBCU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b73KRxXb4109h2GLHm2fEQdYZ3iqhuSIHDkr49po/GrbLMIh4PJpNdw9kJSsB2ZxoEbTSsax4nAOmBapdKYleYIO+OjNDKRHIopk2G+kVT4/49KqoG9l2zi8xoN8IKvaLVwdlIbHtVPt9BgXIlP59f6FLhhHTrhCGkjEttqsMew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-43cd2d12617so2301943fac.3
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 05:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783168350; x=1783773150;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6q0V0DRxWTWBy9oTh1mmUXpQMvbnHaiO3Zjc4WCO/yc=;
        b=jDbmBQ7Qr4kVqej2m1oXldjyTvYfQGi4fKRLzbO/VpXUHoOGtNxxdKatWXE/CI4jar
         DBDsraYqt7CCP/GZPgc4NAeLFjPkzUbUpHd8/UVhQX57pu2VRVGzmqtlI4ajSk7IIEo0
         fBhhcN71klKDVRImi3ilJOvG9Yh0OkZSGG4sQIpwAkVq2KRDRR46YyF0IVWG5rRUeiWY
         N7FJPpbLD8gq6pfP3YHWqHeQFvqtngPOpsV/aKYM1X6kyUIt9bOZwxeolWhz44GTCw9Y
         jCw9+SAiMlx1Eab98mWE15uGiM5NdUR9BEz9JzZt3Hq28Vj40VBFo+3ODsZCqEPkYUlb
         jMXg==
X-Forwarded-Encrypted: i=1; AFNElJ+8cnASuCE6irgd6AUPJvDWgYUPc6B3oGrx1lHeXrRTuo0WBpzLiBV133tH4wfcNERQLWE6oV3pt/7yEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAmiSboBIKNiRMMYQVwbxd8GLpvgUbYHlEA8ANyMYLnEFvkibH
	MF/ix9t3VlXIczyADuk0WvBNeGle827v6fOR7/SNspl+eGjXHs4PNFu2hxtlwMXMl3N7F4NB3rY
	51zJqHntoUCVtjp2n/kZb17YP2ghLy0lAbJ2Z9G3r+pTqbsDV2eREe1FDf4U=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3a0d:b0:495:d0dd:c6d4 with SMTP id
 5614622812f47-499b78013a4mr2230999b6e.13.1783168349967; Sat, 04 Jul 2026
 05:32:29 -0700 (PDT)
Date: Sat, 04 Jul 2026 05:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a48fd5d.34acba0d.1e07b.000a.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Jul 2026)
From: syzbot <syzbot+listce982f98d810f528a2ee@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 3 new issues were detected and 2 were fixed.
In total, 24 issues are still open and 118 have already been fixed.
There are also 13 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  66      No    possible deadlock in btrfs_dirty_inode (2)
                   https://syzkaller.appspot.com/bug?extid=415a049af48761105c01
<2>  47      No    possible deadlock in btrfs_quota_enable (2)
                   https://syzkaller.appspot.com/bug?extid=3a88c590edd72179657c
<3>  43      Yes   WARNING in btrfs_destroy_inode (3)
                   https://syzkaller.appspot.com/bug?extid=25df068cd8509f8c0fe1
<4>  8       Yes   WARNING in can_finish_ordered_extent
                   https://syzkaller.appspot.com/bug?extid=085adc3f91549d11066a
<5>  6652    Yes   kernel BUG in close_ctree
                   https://syzkaller.appspot.com/bug?extid=2665d678fffcc4608e18
<6>  890     Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<7>  484     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<8>  53      Yes   INFO: rcu detected stall in sys_readlink (5)
                   https://syzkaller.appspot.com/bug?extid=23e14ec82f3c8692eaa9
<9>  32      Yes   WARNING in btrfs_free_reserved_data_space_noquota (3)
                   https://syzkaller.appspot.com/bug?extid=9064acebb06685edb243
<10> 31      Yes   WARNING in btrfs_finish_one_ordered
                   https://syzkaller.appspot.com/bug?extid=6e54e639e7b934d64304

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
