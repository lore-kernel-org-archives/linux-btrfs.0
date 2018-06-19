Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f199.google.com ([209.85.223.199]:44676 "EHLO
        mail-io0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966449AbeFSS1C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 14:27:02 -0400
Received: by mail-io0-f199.google.com with SMTP id f12-v6so772855iob.11
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 11:27:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2018 11:27:01 -0700
In-Reply-To: <20180619180539.GV24375@twin.jikos.cz>
Message-ID: <00000000000009b775056f02d421@google.com>
Subject: Re: general protection fault in open_fs_devices
From: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>
To: clm@fb.com, dsterba@suse.com, dsterba@suse.cz, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com

Tested on:

commit:         b0b8c45747a5 wip streamline uuid locking in btrfs_mount_root
git tree:        
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/test-syzbot-fs-devices
kernel config:  https://syzkaller.appspot.com/x/.config?x=26c272eeaa8c437e
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Note: testing is done by a robot and is best-effort only.
