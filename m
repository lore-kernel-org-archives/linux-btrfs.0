Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42246 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030309AbeFSSIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 14:08:31 -0400
Date: Tue, 19 Jun 2018 20:05:39 +0200
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>
Cc: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in open_fs_devices
Message-ID: <20180619180539.GV24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <000000000000832e70056df8fb38@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <000000000000832e70056df8fb38@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 06:17:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1732a6f7800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
> dashboard link: https://syzkaller.appspot.com/bug?extid=909a5177749d7990ffa4
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=16ba31f7800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d4ac8f800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git test-syzbot-fs-devices
