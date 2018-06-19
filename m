Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f197.google.com ([209.85.223.197]:41889 "EHLO
        mail-io0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030225AbeFSRSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 13:18:08 -0400
Received: by mail-io0-f197.google.com with SMTP id v4-v6so643036iol.8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 10:18:08 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Jun 2018 10:18:07 -0700
In-Reply-To: <20180619171513.GT24375@twin.jikos.cz>
Message-ID: <000000000000a63ad7056f01dd32@google.com>
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

> --
> You received this message because you are subscribed to the Google  
> Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an  
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit  
> https://groups.google.com/d/msgid/syzkaller-bugs/20180619171513.GT24375%40twin.jikos.cz.
> For more options, visit https://groups.google.com/d/optout.
