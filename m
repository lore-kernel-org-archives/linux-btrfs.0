Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164E3355F53
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Oct 2026 04:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791261209; cv=none; b=F1p9JcU1whgTRTGzy8qvwzwqMldLyzMicwdqzuj1lq7TLbkzIVdMDgylHCPaHSnD25vvoDQq+olUfegcJfa+i5teVGKRdekthynT1OAaGV5ylhYXIcWepEUJe3c5fGr/flgXODN1wdQF5Cnca3Ujjv7U3dnBeexB7hU8jK95xYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791261209; c=relaxed/simple;
	bh=TPQh6rTIX/gZZyJCTtne5fziJL3GKDMLkYWOMw9k8aQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=s6h2QullT8LK1hJzrmyAuXf8C0Ef40EEyjAG8Kc2x664inXSLCFpsl+444h0cxaBVsW843TEUsRVycOGrz6bz/VU9bLRszstxfKoQiQczzO0iUKQz7aZfFymEn4n4oB8rxNuanROIvhTLfibfZhVT2l2F4nw/7r232wKRkdZqwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f4612a1a5cso770773b6e.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 21:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791261207; x=1791866007;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zrg5BIca4AwANRj/WsD20bdS0Vw2AOmNxaDcNDdgpHg=;
        b=xYjp25573CN3RkO2MhXW5uBxRAQsN2Klf8SIhIpQ3KR4GMiaiMPDEHMXLUxUQ8Tm4Z
         FCjKj1SE/5zYyue6cCtnJuEvtlsvxqyqoDs20OFOFHdmP+WA/4nKgSDppofVbhSUPFXj
         gvy1468qmDujGV0tHWt46ZybwbJyUrPSIfLAaVCRjh9znRYuXQ5X7C2d3GpMVpY8GK58
         tCcmOr7iCyXPvbwBIqi6w1B7sEATjpj3ucfN9/WUomw07S/VaJAE/Pipa/IkS8s1H4QP
         NXgpLWCrHetE740p8XlIeE5j1LT47aklBbolSW+Zv1++W3Qe73aokpbiONCyfyy58+d/
         4eEg==
X-Forwarded-Encrypted: i=1; AKwUvBx+UyQl+yls774k9HLvcT+6sw8UREpQOt5O2u0gcd8VKIIXF08YN48Y0wNLg3HREP4REHvIMscsbIyo9Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lMmtGSGddJGGG1GtD/foAwLE1ovP82rZl3/xFBEl78opB9k1C4
	bwhfBamFQmxQvyzdj7uLbPXAe0AGQab7JLW67B+ioALwN9iP7rRNfgzW+LrB4nyqII9WTIDWWCj
	Sl7l1WkC7sIeew66zPcsWMgOsiiYxvydrnvQflJHQG9igAvby+dx2t08lHBM=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1311:b0:4b8:4703:db97 with SMTP id
 5614622812f47-4faae80f6b4mr1274352b6e.32.1791261206928; Mon, 05 Oct 2026
 21:33:26 -0700 (PDT)
Date: Mon, 05 Oct 2026 21:33:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac47a16.598348e0.18b15.0007.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Oct 2026)
From: syzbot <syzbot+list2dc5df84d7b9a27e23fc@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 2 new issues were detected and 0 were fixed.
In total, 33 issues are still open and 121 have already been fixed.
There are also 15 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  208     Yes   WARNING in btrfs_run_delayed_refs (2)
                   https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384
<2>  88      Yes   INFO: task hung in __alloc_workqueue (2)
                   https://syzkaller.appspot.com/bug?extid=ead9101689c4ca30dbe8
<3>  78      No    possible deadlock in btrfs_dirty_inode (2)
                   https://syzkaller.appspot.com/bug?extid=415a049af48761105c01
<4>  51      No    possible deadlock in btrfs_quota_enable (2)
                   https://syzkaller.appspot.com/bug?extid=3a88c590edd72179657c
<5>  32      No    possible deadlock in kernfs_add_one
                   https://syzkaller.appspot.com/bug?extid=f50d605480fdec503770
<6>  21      No    kernel BUG in btrfs_subpage_assert
                   https://syzkaller.appspot.com/bug?extid=d490d04560554e6259b9
<7>  1279    Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<8>  581     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<9>  74      Yes   WARNING in btrfs_finish_one_ordered
                   https://syzkaller.appspot.com/bug?extid=6e54e639e7b934d64304
<10> 35      Yes   WARNING in btrfs_free_reserved_data_space_noquota (3)
                   https://syzkaller.appspot.com/bug?extid=9064acebb06685edb243

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
