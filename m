Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f69.google.com ([209.85.214.69]:33209 "EHLO
        mail-it0-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732289AbeGJTI0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 15:08:26 -0400
Received: by mail-it0-f69.google.com with SMTP id p82-v6so7190207itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 12:08:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 10 Jul 2018 12:08:02 -0700
In-Reply-To: <1485a21d-cc34-1872-a1bd-c5d383656357@oracle.com>
Message-ID: <000000000000613a9e0570a9d9b5@google.com>
Subject: Re: general protection fault in open_fs_devices
From: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>
To: anand.jain@oracle.com, linux-btrfs@vger.kernel.org,
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

commit:         d38c078c856c btrfs: add helper function check device delet..
git tree:       https://github.com/asj/btrfs-devel.git/misc-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3049e25df7e85a
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)

Note: testing is done by a robot and is best-effort only.
