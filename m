Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65322FFFBE
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 00:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888038; cv=none; b=KDgiDEFSqShySp2DOqiRjSC8f9Mpo/yStK6hgDu6RWbL4mSEaYivhkmehSdrXi9xINcmAEbMRm+b4ysQywfXjzL0fsNjNJAYTfsaLycykpqHxpz/qR3c2g92pKBGQYeJtiFS8miMxFm5EQVHk8GoK9sc+1pacD6qXTroLtlTgyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888038; c=relaxed/simple;
	bh=1STPsp4C9HCKwQYla/XMSrszVwwAaMoj5UlOwIAnHq4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OA4bEn1ceK+ZF+AheffVghlcwbSAEdDD4y6uJkO1mdAs1UCxvsKqEIEhh9u1HCKwVkpYnq8owIU+FngkesaWdpU5UwWUeZMG87KaN7YJm4WP99s6uqY6+69fYjWefzsVPobd/gnLudR0TEOf0euUlLDEl7TVGjbl8A/pl2Y3I44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6acaccb8b0cso349739eaf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2026 17:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785888035; x=1786492835;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P9pPMj1iJ3xafh3apgLpB1ueVfFMD3biiIhGqGMirfk=;
        b=XcdMMeK1dt7PBw46upo83tfREOAaBq8GsWCM1X/Kscpvi2wi2GLVR5XvNQtf9pFYbV
         xDxfhaddWTf8WqDO9l+ZsDaDxvXXxKkyHN1jlKDhHQ0Wb6Mjs21l4z6ObrnQJ8+qQ2+N
         zkbvmiBWFBqk0kS1GN9GEomBC80bjzEHrvy3Vxt+lNDQMa14DhiSuKhJ8/K18GwF/Eq6
         c8o4FD6qrrXTUrGO/1atBbizSGNYsSQ05FDtRNPnnRXReRGcNLIGEBFU/cYRw94I9kXy
         esO7PfhkSRr9csaf5quwZbGKGZ4iEu/3rNzVlYHqWdBiQtFshvf6cKJOESz0+4qFYifi
         37Hw==
X-Forwarded-Encrypted: i=1; AHgh+Rpw2wZVZ8ilrEwyG4tWXqpkaAl+wO1jrJx/D2IjUI2cS5OYO8NOaLwwrdmd9SIP7zJsLn2vvAqfBsox6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWuaOxjcq4Z/GCKEiw8kBIalQxQtraWwbntTX9hNkzhBqnTR8R
	fSUNdZZOr+T19GO6bKx/c95JHjO0Ya8kon5Va4KjiMxg8/tfjbq53GdVf8E83fAF7NiKm2Hv1Vk
	L/daKQYiXRpzJFRdyoCsUtdJTGSXV0ZiD/fiBcAznFitGVg4VFZp33lWZeKM=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f00b:b0:6ac:aa52:5a16 with SMTP id
 006d021491bc7-6ae96f95281mr1364798eaf.25.1785888035444; Tue, 04 Aug 2026
 17:00:35 -0700 (PDT)
Date: Tue, 04 Aug 2026 17:00:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a727d23.40259c87.584f4.04cf.GAE@google.com>
Subject: [syzbot] Monthly btrfs report (Aug 2026)
From: syzbot <syzbot+list93ff57ed75573217e846@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello btrfs maintainers/developers,

This is a 31-day syzbot report for the btrfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/btrfs

During the period, 3 new issues were detected and 0 were fixed.
In total, 20 issues are still open and 119 have already been fixed.
There are also 13 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 219     Yes   kernel BUG in btrfs_alloc_ordered_extent
                  https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
<2> 68      No    possible deadlock in btrfs_dirty_inode (2)
                  https://syzkaller.appspot.com/bug?extid=415a049af48761105c01
<3> 18      Yes   WARNING in can_finish_ordered_extent
                  https://syzkaller.appspot.com/bug?extid=085adc3f91549d11066a
<4> 6653    Yes   kernel BUG in close_ctree
                  https://syzkaller.appspot.com/bug?extid=2665d678fffcc4608e18
<5> 1023    Yes   WARNING in btrfs_chunk_alloc
                  https://syzkaller.appspot.com/bug?extid=e8e56d5d31d38b5b47e7
<6> 485     Yes   WARNING in btrfs_remove_chunk
                  https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
<7> 38      Yes   WARNING in btrfs_finish_one_ordered
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
