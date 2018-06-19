Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967097AbeFSRUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 13:20:11 -0400
Date: Tue, 19 Jun 2018 19:17:20 +0200
From: David Sterba <dsterba@suse.cz>
To: syzbot <syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com>
Cc: clm@fb.com, dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in close_fs_devices
Message-ID: <20180619171720.t2tgzr5aonqzo2c4@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <000000000000b9e25a056de4dd10@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <000000000000b9e25a056de4dd10@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 06:17:03AM -0700, syzbot wrote:
> syzbot found the following crash on:
> 
> HEAD commit:    716a685fdb89 Merge branch 'x86-hyperv-for-linus' of git://..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c5f46f800000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4f65cd4286737868
> dashboard link: https://syzkaller.appspot.com/bug?extid=ceb2606025ec1cc3479c
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1251799f800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177f3edf800000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com

Again with the right syntax:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git test-syzbot-fs-devices
