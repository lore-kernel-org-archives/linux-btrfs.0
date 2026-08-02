Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DB11F3B85
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Aug 2026 04:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785644644; cv=none; b=N15w4gVHq8+5730kJtzW1L0CR9iLLDev/EMcPTWZsykDeY/7Q2Lje0BnZ1p8/94zzxPlpEVyGx8b5a18rZYXA6hWI3iSqTW6u6PViqPJKDCH0q0v1fYYpw820LjdNYqt/4ZAcdS6jRsDvHs3xh6lPqMBU6iPpME4eFM72aeeqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785644644; c=relaxed/simple;
	bh=KOrt880ok+b2ybm+gIaenK028UTcVFXcsjYmgBwOjEk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=G8SNtweVpeck4lY5H14cyWdT708vf8KC59Mu5Vklyex9IzYiII9NPDIRTgIWhyenwZmDxA1xYWk2ejQTKyEO65Zh0jnvX1CmAmJ+LNVJHXoCTUEh3Pz94F05XZeS15Xopotvg0/2y0xMTjXyloWzdTStVlr/ADaKmD7mw/q6lrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a7de733fa9so2982953b6e.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2026 21:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785644642; x=1786249442;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zbFq40ZlW5pYZSpdbNJCeHp3/iKAKdIa3b1hd8I0LLg=;
        b=Uu1tkQdD9yiJX07UcrwuRRip1Cd0GJ3J03GJAum8TISPZ7UsnSTRDtiUYSdoZrQZOo
         PckHZtY5W7ee5RurXoKsejjlQGorNIt6lROhGH7AJbAVCIjLjyyUJJfMBPiwoo3NQ/lx
         FKRe/O/mNkc7RA82AZ5/cHkBiMtYWAQFuVY8dw6KuSj7jNikJ86H0Z76Lw+6MBkDZJBZ
         kDsvl4rssrwaWXVgfDQAh7C1hdS/6CFttQ45OBxqal8Fu12sIzp6U33alWRpxz1oz0RT
         +jQTPAlZ2pc0tGx9HI+hEVpLqqqxKSFquSfDgXv2DxsWD1Q1ThgyqP3+F/crC2idKVpW
         gOVA==
X-Forwarded-Encrypted: i=1; AHgh+RrFvuC5IOldyCAeRtaHHir9gSdgxp3EV/iaQAM5ZJHNfSDcYtgbui732Q0RArcoXGCLwXGw1peWWCl/cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyt6rKYOm4+Aov1b/1KA4PsEemoxIU8vA875Z1z+8t3DddM+qQ
	8PhlssSQo/ve0UuJvwbkr6bmkPhgwnzhDpQyxLSdOuKfENY87uA7TmGhNWl5oa98EpNCGHhSNB5
	fWoroHThbl0Dw7Zo/aNdIN/nntdLelM0G3rRHCW+6YHwq9Al8w1cb1hDVKa4=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3a12:b0:4a3:fefb:899b with SMTP id
 5614622812f47-4af5e06ad5fmr10394073b6e.7.1785644642289; Sat, 01 Aug 2026
 21:24:02 -0700 (PDT)
Date: Sat, 01 Aug 2026 21:24:02 -0700
In-Reply-To: <000000000000e93ea70620fe777a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6ec662.6ce73036.24301b.001b.GAE@google.com>
Subject: Re: [syzbot] [btrfs?] WARNING in __btrfs_free_extent (3)
From: syzbot <syzbot+480676efc0c3a76b5214@syzkaller.appspotmail.com>
To: boris@bur.io, clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, nogikh@google.com, 
	quwenruo.btrfs@gmx.com, syzkaller-bugs@googlegroups.com, wqu@suse.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 1e92637722ae4bd417f7a37e8d1485dc23b93935
Author: Boris Burkov <boris@bur.io>
Date:   Mon May 11 20:07:11 2026 +0000

    btrfs: check for subvolume before deleting squota qgroup

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e815b9580000
start commit:   f5459048c38a Merge tag 'i2c-for-7.0-final' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=45cb3c58fd963c27
dashboard link: https://syzkaller.appspot.com/bug?extid=480676efc0c3a76b5214
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c65106580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15261036580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: btrfs: check for subvolume before deleting squota qgroup

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
