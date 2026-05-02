Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93592C030E
	for <linux-btrfs@vger.kernel.org>; Sat,  2 May 2026 20:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777753943; cv=none; b=Irft6Ic7zH4sZO6kK/G3ZBIRdoI6QRc8sGHAXd+3ks+LEKA22KQBYn3D4qK8rq9oHigDDkcfj0ix0QfprmMZm0TlbjAtI8DzgIediXN623hGlOEb58+Eg/zYH/EzmffI00x81iG5ec4I2Mk1QHwEsR/Ek8d6bKwFwVC913PGH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777753943; c=relaxed/simple;
	bh=HAaTem14nkaSO4adntdVlnBkMEB7DUn62oG4gzRWtXY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WO0JWf3kacRJVhqjjJXVl3MDcvA2YGuDPq+INXoBROMlQlOaJbd90j6S87wkmKyriMvJHswjZKClM+eKWd1R2v+1WfhVZzGaxoQzJi+X8+3Y0o0qhOm7ax+sgs3Odo60vfYFl3j+X3n7TjHrxW4gbzL6O0ehcpKFCmsXGwmIko0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-415e1ea16b4so10249617fac.1
        for <linux-btrfs@vger.kernel.org>; Sat, 02 May 2026 13:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777753941; x=1778358741;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rHFi1NmeB0NHDCFRjSf5jzoE1FkG+RT4CoH0Z83TUXI=;
        b=iNWymPWhaTqNYKpcnbudq5W1xfO7tDd7SnZMAplydVqUG4oGcpB0qnPlGaHYRYTxKM
         2a5OLHABt1r1Qp8oIXeJC8eBzowJOeRrrvvPaVIR4fSH87wzrEyk5/xD/QUo4jRs1c50
         p9N7Lrktyx1K4exkDGCFVQC8d07TzFT6miq1JIhKtrCAnweRZ2maDkxtLV0xeEZlwd1R
         6lrTOEKYI7Zq/6v99L4+x7RlZgogyZU39XwO+x0AXYyaCK3wTNyUVP77Uz6JfcMFB7IA
         03d7CXybHWfT06jyKoGl436eomE7Nh26FAL6uvp8N8Dalo0P/TZjinq3EHw3viGerkVs
         WuMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vm4uhP8tum/6Uych0YOCc0j9V1djgtdpEEOAoljR3fYahwWQDQsVYhn4qIX3jYDBeWrrHzoc/ajYAEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOLk1mCZZk9UEin9cocQSIvoHPhSBv7k6KbSreXIWSlGwSyUXC
	2dsw3wYzllwatiCOHd/ZacodGRnJzGjO79SesPUW1cDFPgzyRoRxuH/MRiRbzLyfhWEBw5Yh0Oe
	3xR3cvWDPIM6kLpVFNzdlpZ5a/5WCkXid/jzCnIbR8T6wB8VCzBwvFQh8RAA=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0e:0:b0:694:914f:c18f with SMTP id
 006d021491bc7-696979c9863mr2002728eaf.3.1777753940903; Sat, 02 May 2026
 13:32:20 -0700 (PDT)
Date: Sat, 02 May 2026 13:32:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f65f54.050a0220.312cd3.0024.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (May 2026)
From: syzbot <syzbot+lista42c399bb92bb3d4ac4e@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 32 issues are still open and 114 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  11326   Yes   BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low! (7)
                   https://syzkaller.appspot.com/bug?extid=74f79df25c37437e4d5a
<2>  5639    Yes   WARNING in btrfs_space_info_update_bytes_may_use
                   https://syzkaller.appspot.com/bug?extid=8edfa01e46fd9fe3fbfb
<3>  1345    Yes   WARNING in btrfs_create_pending_block_groups (2)
                   https://syzkaller.appspot.com/bug?extid=b0643a1387dac0572b27
<4>  783     Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<5>  532     Yes   WARNING in cleanup_transaction
                   https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
<6>  473     Yes   possible deadlock in lookup_slow (3)
                   https://syzkaller.appspot.com/bug?extid=65459fd3b61877d717a3
<7>  472     Yes   WARNING in __btrfs_free_extent (3)
                   https://syzkaller.appspot.com/bug?extid=480676efc0c3a76b5214
<8>  457     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<9>  271     Yes   WARNING in btrfs_release_global_block_rsv (2)
                   https://syzkaller.appspot.com/bug?extid=48ed002119c0f19daf63
<10> 163     Yes   WARNING in btrfs_run_delayed_refs (2)
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
