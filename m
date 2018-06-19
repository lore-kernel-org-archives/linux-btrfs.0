Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f198.google.com ([209.85.223.198]:54787 "EHLO
        mail-io0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966514AbeFSRSG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 13:18:06 -0400
Received: by mail-io0-f198.google.com with SMTP id p12-v6so629628iog.21
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 10:18:06 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2018 10:18:06 -0700
In-Reply-To: <20180619171513.GT24375@twin.jikos.cz>
Message-ID: <0000000000008b7ae5056f01dda9@google.com>
Subject: Re: Re: WARNING in close_fs_devices
From: syzbot <syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: clm@fb.com, dsterba@suse.com, dsterba@suse.cz, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Tue, Jun 05, 2018 at 06:17:03AM -0700, syzbot wrote:
>> syzbot found the following crash on:

>> HEAD commit:    716a685fdb89 Merge branch 'x86-hyperv-for-linus' of  
>> git://..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15c5f46f800000
>> kernel config:   
>> https://syzkaller.appspot.com/x/.config?x=4f65cd4286737868
>> dashboard link:  
>> https://syzkaller.appspot.com/bug?extid=ceb2606025ec1cc3479c
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> syzkaller  
>> repro:https://syzkaller.appspot.com/x/repro.syz?x=1251799f800000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177f3edf800000

>> IMPORTANT: if you fix the bug, please add the following tag to the  
>> commit:
>> Reported-by: syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com

> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git  
> test-syzbot-fs-devices

unknown command "test"


> The patches are work in progress but pass fstests and should address
> these syzbot reports:

> https://syzkaller.appspot.com/bug?extid=ceb2606025ec1cc3479c
> syzbot+ceb2606025ec1cc3479c@syzkaller.appspotmail.com

> https://syzkaller.appspot.com/bug?extid=909a5177749d7990ffa4
> syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com

> https://syzkaller.appspot.com/bug?extid=923aa93978c7ad27a9b1
> syzbot+923aa93978c7ad27a9b1@syzkaller.appspotmail.com
