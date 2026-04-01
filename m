Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F3408239
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775049271; cv=none; b=ZKH3Gz24h2zMzGiNnMtTnASz9rkdIDeOzcRHN1/dlJxcWEaNjf92gWmgRJJ336tR00iUSIpUZm6vEaCGgnau4GJzkm7qY9AZr5fVg7EOg41Xg/xDd9tIHRvYE8BbovFcr3BliIMbDXBZCTiDwhf3krGW5t9zjfcAw1CysgQml2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775049271; c=relaxed/simple;
	bh=gmgKK+52kKGCNZKI/AqUKm2oEFhxiZSLkwVe/bR2hMg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PyCmPX19GdAfqxBDkhFAjkW3FOLA8LRkjX1HTSn0tANvmH0rKaAZ4ejyK6aluGmQ7ogGkB0WMeTovhOHYt0a2JDyvJf69qzBX+EhDgaToWJTrNEsUZDz0dMItj5Hfk/PtZRHw1RQGrpMby3a+Zu3QHCj35unPxaL1yos6dQ4S+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d7efc5a904so24748914a34.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 06:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775049269; x=1775654069;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oaoURK3VUsi+ML3GoQFhgIFDCW8aByf7V6eH/nReFto=;
        b=aaAbZA+reKWs+1DD6WjadVCvlybKtBRGlu0pDAmza/WyhpMT/EQsfBV55LL/Qog4lf
         GxDrpA+1T2TidO66gwcquuy5Y50l/bQKIgJon2L6qPu3667Sj5ighHFz6Crjp7NGKJpI
         h9CMmN52kpD9ZhVHhNVr6w/ajQ60l764nBW9jRqcOuJ83RTba89ZWIeJnNoGKd4cxZay
         bfuqL5D7j7n+ZSHGqEMpNlW4kn0Gzvc0BkgkEl5W0TXdx+HJVn3vJBNUwbinzpH5DjFm
         m29J5YjxxT5YZs2tX4yU3X8tSLuPwO388n/7P0EkXlFq47GliJEXnpitr+A+BTkjDzNb
         0sMA==
X-Forwarded-Encrypted: i=1; AJvYcCW77UecgVuVj9SbwuGbF3jddUryiGlh05GF+/JD/0abBkkVPpTUjuv1ZRUs01oNLN+/wOWMvwjcZ0gqCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWhPcIknNnpjY1h53GpxRnuTisNZTuk0giimkfK55GjrPUosSR
	LSD1ig5EwPdTsm8jvIvWpJIsizpv4sPPU0ni+CAmOo3ZZLvz32y/wx9TwpfkUTjeuabanckW0Ua
	Z4um0jSNYKW8g5ppA0uJXihiOiBWh4KpJLc2eWmVG+6XDqfnz6rLs4jQQdTw=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a01:b0:67e:3a2b:922 with SMTP id
 006d021491bc7-67fabcd4bc2mr1489996eaf.48.1775049268852; Wed, 01 Apr 2026
 06:14:28 -0700 (PDT)
Date: Wed, 01 Apr 2026 06:14:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cd1a34.050a0220.31cfc4.0025.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Apr 2026)
From: syzbot <syzbot+listb55e37864f7b36453c37@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 2 new issues were detected and 1 were fixed.
In total, 34 issues are still open and 113 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  6586    Yes   kernel BUG in close_ctree
                   https://syzkaller.appspot.com/bug?extid=2665d678fffcc4608e18
<2>  5612    Yes   WARNING in btrfs_space_info_update_bytes_may_use
                   https://syzkaller.appspot.com/bug?extid=8edfa01e46fd9fe3fbfb
<3>  1342    Yes   WARNING in btrfs_create_pending_block_groups (2)
                   https://syzkaller.appspot.com/bug?extid=b0643a1387dac0572b27
<4>  763     Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<5>  529     Yes   WARNING in cleanup_transaction
                   https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
<6>  454     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<7>  268     Yes   WARNING in btrfs_release_global_block_rsv (2)
                   https://syzkaller.appspot.com/bug?extid=48ed002119c0f19daf63
<8>  254     Yes   WARNING in __btrfs_free_extent (3)
                   https://syzkaller.appspot.com/bug?extid=480676efc0c3a76b5214
<9>  189     Yes   kernel BUG in clear_state_bit
                   https://syzkaller.appspot.com/bug?extid=78dbea1c214b5413bdd3
<10> 106     Yes   WARNING in btrfs_run_delayed_refs (2)
                   https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
