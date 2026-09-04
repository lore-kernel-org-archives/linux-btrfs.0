Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697F251FCB8
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 20:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788554026; cv=none; b=BTotcqpY1WS/3leO6geCdU3kF9cZD2M1vvcOk9Kx9tz0sDYWb+kqCtPlwMmUHU5gCt760Ii46KFG7e7HMdMNSKGnVx8W5oPEEqaka2es6f8O//80Ddztxn43vJNsSj6C8SLfv3NEyXaww6rCSA4Sfc7bGG3m+OO3N7NVIMtiomU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788554026; c=relaxed/simple;
	bh=WWpnEqPnpbR/yuawFiBdEyhlCxR0V0JrLt7mt62L9fk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Wrsz5l3/iONoL44tPUyBAW7LMo0HSby9pYMTX7P2XB5GLIlN+DWOAUhlRfZSPjDNeE9kPhAwTvMTcC2KU0Zwa+upffPdWU89lHR/SEOtpU7AVR7IWxrrXtRoMKXUzoO1RcxkQnGPjLKAzD9FpYoGoJzY20FUCCXXeBUqONKYKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6b12ae7394cso2100022eaf.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 13:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788554019; x=1789158819;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WCIRxMwU7FkF5NClnWliGt7Fjn0PVFIZ1AwuQ3Y3wP4=;
        b=KRX7CBbLMkFK/Ht1+t360bDLTTTYR2zVbtXd9xRJEZ9pF/M8BBqRdLwwFIEOAXwvqp
         p7yBLu5RLXmq2dPqcWvyu2DHk8DzH/fjXvjXaPBSWmyspAMhmzrkVkYZpJFLm0/mOit/
         yy4ZxE7jpzMZ5Ugr4QbZZqywB3YiipANDt7igZJDbGQpviKpuULKKpULr2i+mPpg53GY
         0/Tk4TTy9T+ltlmzgduNeUuI9lsBAMw7T+rHqJLhctbNvPOch5gLkbMWXPYQx6KrGZel
         9ZW6wu4dtqT8tn+z09ftS5bYQKR4cv7X/F13drcQPS3s9Se0gCkx4FPA1YuCoGIKF+3B
         Bf6g==
X-Forwarded-Encrypted: i=1; AKwUvBx2cZM9aVKG/9HMLy6HKr3XRKakMQFSmK3V+tq+mJhPQIlpDpJ3UAn24qqu9ipQXPeQdpg4roBy3J+6qQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mInmAMLHEK592sesmbu5zKxkfkpvZ2YRCFXq1Rf/JqltwIwYT0
	RqAnpSyNjtz9QPZxP8dOnnd3iCxSnudD0uLM/0PFEHDXQAvC84/0wG8YbPzjfYvq3A6tRDtfcdv
	ahEuGJ54Adm77DsXfU0Ifl7ipLJkdd3+Lf67S068OIsoFKt2T7NQNCNgIiKY=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4cc8:b0:6aa:de29:651 with SMTP id
 006d021491bc7-6b6fbcd091cmr6577744eaf.16.1788554019269; Fri, 04 Sep 2026
 13:33:39 -0700 (PDT)
Date: Fri, 04 Sep 2026 13:33:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9b2b23.b5d4176b.238c3e.0005.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Sep 2026)
From: syzbot <syzbot+list28cec74617be14fd94e2@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 8 new issues were detected and 0 were fixed.
In total, 30 issues are still open and 121 have already been fixed.
There are also 12 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  198     Yes   WARNING in btrfs_run_delayed_refs (2)
                   https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384
<2>  78      Yes   WARNING in btrfs_destroy_inode (3)
                   https://syzkaller.appspot.com/bug?extid=25df068cd8509f8c0fe1
<3>  71      No    possible deadlock in btrfs_dirty_inode (2)
                   https://syzkaller.appspot.com/bug?extid=415a049af48761105c01
<4>  15      No    WARNING in __add_block_group_free_space
                   https://syzkaller.appspot.com/bug?extid=6931616d57696102d8aa
<5>  15      No    WARNING in __btrfs_update_delayed_inode (4)
                   https://syzkaller.appspot.com/bug?extid=768687d6d7c96a124e24
<6>  13      No    WARNING in btrfs_create_new_inode (3)
                   https://syzkaller.appspot.com/bug?extid=c1b8c52e6c0142c5e448
<7>  1105    Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<8>  511     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<9>  52      Yes   WARNING in btrfs_finish_one_ordered
                   https://syzkaller.appspot.com/bug?extid=6e54e639e7b934d64304
<10> 47      Yes   WARNING in btrfs_init_new_device
                   https://syzkaller.appspot.com/bug?extid=3bf3e110b2d406b8166c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
