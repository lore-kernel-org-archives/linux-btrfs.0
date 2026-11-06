Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968429;
	b=4zeueNt+PLeovjmeZISe0PCJ57fY3QdcSrtzKGM9GMC2nh7MCnPHHjYTt4+ftmyHEfcW
	 PxA6EuKXhzOdBERRXzD0ELIY9xmpEUWj18DguOnz1LegFE5BsSscbZMxlXSrtoiZd1cmk
	 1usyFyHwY6tommSCW4scEdsQtN5t7VNi744E9OFVNoDub5143Rnm1O1j8ZzTo2rSMesIv
	 3b/SbPKLjo+DFcSO1+eVO6Jyjvdv8Y3X7m+3IBiAJkhgZJNOGREUpfgNZ4zwB0jPsWN3q
	 pkYgXO18KhWRw+726o4jmyaWETg7s2bCWypVVQL/gsDmE/yFJVvYsii5is/ZyaNIrww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968429;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=vOuk4MEEMKLZz9SbU5bzBH5xfiLgItoR3reCPXp3778=;
	b=tQ/q9MLM7J66xa6QEd8X/mQyDzujo7eywGRPpLA/dPt3DqRz1mQJjeDM3Um/S1oT2pov
	 U3UKOXXMYHSouMGT/5pbOADBXHDZ33WnPinH18+lpwzOyeaFPs/VXbeUZ3xbP5Gfg5RCo
	 LPCaLPuItInsP5bQ9nATQsIohLQsxpYFcSvX86MkqScJeHK93PTNyiGjl6e/jmftoc31U
	 3G93aowsb7AERxuk44l6Fgxw/1nWhaIZ4Y5BS2jEY4+9OzgWwrgUgmSD0Hs3f6UzKKP7+
	 dkFYnV3VO/TR+Zk7q67WnVNPMZf3AZP0rTQ5vvGYk34jw1JaAWkvfqXkLs3z4HWu8hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EAD606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 12:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51EAD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-85a6d046af0so706927a34.2
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 04:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793968428; x=1794573228;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vOuk4MEEMKLZz9SbU5bzBH5xfiLgItoR3reCPXp3778=;
        b=snk4kptdwKEvDZV0avlc3h4YKFS+4FEngSX0alRWS6oPU42K9kvPFKFIuWPztxcHg9
         C9u82MvcuLp2jfXU+Hq96Yco0j10J8+q6XZu5Jd2TW7lDNVZ3WzbuERWexrsHYbgEPUS
         BYEEZJCGdC585nOcMNvmDa66BqpEmk4qe3ncoQpqD/N3IVAV7vTpE1OpF7UnUuI76axW
         CzMhOHYimc+t7JiyzY7s8WQu9Y+wlDVwpEO6eDtyfuSSLm0SyTUxOxSZpZRtmY/+3oj9
         28kc1+1zp+7xhmAnz6hkiDK+c/Iq139DyCCaId/m1Pc7VZCKF3y3HCJK3B7SbVcGTaxa
         5SoQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1kZW5CiY1+cXAN8AZIwzDyIrRKOPjP888jPYySuv77kg1VoHT3R8pBSeZFQvrj8d3IqIyUF5k6avC4g==@vger.kernel.org
X-Gm-Message-State: APuU4Z9xhGaMbBK60emSx8B24U30lPC1NMQsIV+8LrE8MzA0lUSl57Q6
	qpdtlBSdtGvXyNPIROpSQWYMCIZtU11NjbW9LX+ulhCq2IEYVNLbMDC5YXLrU2bDDd/SY3ONrUx
	z06YYGT5TLTx1cc6IfGjsIlNKP+g7487LznIqRJ6Wud8SanIrY87pzdPk+4g=
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2d6:b0:4c3:ebb:63d6 with SMTP id
 5614622812f47-567e11247c7mr1568823b6e.39.1793968428434; Fri, 06 Nov 2026
 04:33:48 -0800 (PST)
Date: Fri, 06 Nov 2026 04:33:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aedc92c.a716b02e.a4a62.0001.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Nov 2026)
From: syzbot <syzbot+liste224054b66e11f54d148@syzkaller.appspotmail.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 2 new issues were detected and 1 were fixed.
In total, 31 issues are still open and 121 have already been fixed.
There are also 14 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  213     Yes   WARNING in btrfs_run_delayed_refs (2)
                   https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384
<2>  113     Yes   INFO: task hung in __alloc_workqueue (2)
                   https://syzkaller.appspot.com/bug?extid=ead9101689c4ca30dbe8
<3>  63      No    possible deadlock in kernfs_add_one
                   https://syzkaller.appspot.com/bug?extid=f50d605480fdec503770
<4>  19      No    WARNING in __btrfs_update_delayed_inode (4)
                   https://syzkaller.appspot.com/bug?extid=768687d6d7c96a124e24
<5>  17      Yes   WARNING in __add_block_group_free_space
                   https://syzkaller.appspot.com/bug?extid=6931616d57696102d8aa
<6>  17      Yes   WARNING in btrfs_add_to_free_space_tree (2)
                   https://syzkaller.appspot.com/bug?extid=554a2e08e4abc56984a9
<7>  7       No    kernel BUG in set_state_bits (2)
                   https://syzkaller.appspot.com/bug?extid=64579ad11e26758151bc
<8>  1463    Yes   WARNING in btrfs_chunk_alloc
                   https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<9>  696     Yes   WARNING in btrfs_remove_chunk
                   https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<10> 79      Yes   WARNING in btrfs_finish_one_ordered
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
