Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEE3382EC
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 04:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780461145; cv=none; b=a+O1zUjGbyJIVzgqxUYyDsQx6XfSHO2wfMamp5Yoio1Z1uKkuCy1UYGSr8CKzQJY3DNnp5DykbiJIj/hccq8L5nO2DF1of8aJo1ah7Cw4pYXWr5pXCTsDkzbwggp5uCFp5t0n9og2sX45KtD+ecFvXaKPG2VeDqpaLfBeBMEBe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780461145; c=relaxed/simple;
	bh=6ubEtTW+zJqU498z0Vm/eeO47xhIJNQhYfnORyinChU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u5VBknabiifFsS7bkaT5VPcRboOa60cn7tPzkX+B8FWgKCaJCkd81rtF7/JOhrFPnx9d0Z7PGXr+enlZ2brNkaFkrD3dUZKu1dExfxENk0KsVUKMz+CLXjrDbr5FNxxsThCTuYE6FIEvUWNPCG///xS/BdGreNZjpNj98LDy6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69e2e3e0736so3363456eaf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 21:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780461143; x=1781065943;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CrVdApsgZJq5f9vVnV2iGDIcmFHMenVc6GQi2HY8XBk=;
        b=bUlHgWOyKqzO/uyEol/oiqL8cnPyaTgKUlUPtCeEiyB7fGutY6X4SeKnO+fg+2HJku
         rNO9CZ/k+rqP5AqpnJzADjD0No6MOSdvbURdIoYF9VnaXeRwLnjFIHyhSFHsqq1l2DcA
         248SribM+9yAWlUq4FxlNxaiIxzIcMx4WTIIUpE7K32mgQIy6fO1w/KWmram81uXEdsC
         BMnR30qNuVZeTewXYZcDEkG0g0o9HUvci6OpcOW8CUwIxb37zVqm8Zxd0+yIy+3wjXpA
         euAVBVyOVAVgVieIWeQCz5HIPJJ4FtTYsKHdon/X2rnxbCZCbBlh9p8IcNyNcE/dQ6wb
         bgdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+EQ7uJYaZFrrrT7nab2XEFrwF5VSkhR7gl7KuIBHkHiqopvqoaT5GLLSuIszHC/BhjyLndWLeln8erVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMDDQfLRkfRdIoz5mnrgZrHCG+YJA06GbOtyi1Y3wHLkXgwv+r
	zS1y/i74POfcfaxsYmdvPsX5mpyD8WUbh6/CWh50exQ/+QRKMqW2TFxSrDHASCDSto7Wy6ZqDcN
	jhTtckBD+Cap7zbZWXl2vbN3vgMugyGOjLR55PB8iNhxEBjSSQkEY/espBRc=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4810:b0:69d:7774:fb51 with SMTP id
 006d021491bc7-69e47e617d9mr985786eaf.12.1780461142795; Tue, 02 Jun 2026
 21:32:22 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:32:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1fae56.3b158e77.2846f8.084b.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Jun 2026)
From: syzbot <syzbot+list2e82c29d724b61416433@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 23 issues are still open and 114 have already been fixed.
There are also 11 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  185     Yes   WARNING in btrfs_run_delayed_refs (2)
                   https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384
<2>  63      No    possible deadlock in btrfs_dirty_inode (2)
                   https://syzkaller.appspot.com/bug?extid=415a049af48761105c01
<3>  37      Yes   WARNING in btrfs_destroy_inode (3)
                   https://syzkaller.appspot.com/bug?extid=25df068cd8509f8c0fe1
<4>  7       Yes   INFO: task hung in btrfs_invalidate_folio (4)
                   https://syzkaller.appspot.com/bug?extid=c7443384724bb0f9e913
<5>  2       No    KASAN: slab-use-after-free Write in btrfs_put_root
                   https://syzkaller.appspot.com/bug?extid=b3d472d13f9d7bf20669
<6>  6592    Yes   kernel BUG in close_ctree
                   https://syzkaller.appspot.com/bug?extid=2665d678fffcc4608e18
<7>  847     Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<8>  460     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<9>  31      Yes   WARNING in btrfs_free_reserved_data_space_noquota (3)
                   https://syzkaller.appspot.com/bug?extid=9064acebb06685edb243
<10> 29      Yes   WARNING in btrfs_finish_one_ordered
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
