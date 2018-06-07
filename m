Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37005 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932124AbeFGQ2X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 12:28:23 -0400
Received: by mail-pl0-f65.google.com with SMTP id 31-v6so6459980plc.4
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 09:28:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180607153450.GF3215@twin.jikos.cz>
References: <00000000000096009b056df92dc1@google.com> <70a3c2d1-3f53-d4c0-13b3-29f836ec46d9@oracle.com>
 <20180607153450.GF3215@twin.jikos.cz>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 7 Jun 2018 18:28:02 +0200
Message-ID: <CACT4Y+arBwkwhD-kob9fg1pVBXiMepW6KBK2LkhwjQ9HnDcoqw@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>,
        clm@fb.com, dsterba@suse.com, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 7, 2018 at 5:34 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jun 07, 2018 at 12:15:04AM +0800, Anand Jain wrote:
>>
>>
>> On 06/06/2018 09:31 PM, syzbot wrote:
>> > Hello,
>> >
>> > syzbot found the following crash on:
>> >
>> > HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of
>> > git://git.kernel.o..
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=15f700af800000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
>> > dashboard link:
>> > https://syzkaller.appspot.com/bug?extid=5b658d997a83984507a6
>> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> >
>> > Unfortunately, I don't have any reproducer for this crash yet.
>> >
>> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > Reported-by: syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com
>> >
>> > RDX: 0000000020000080 RSI: 0000000020000040 RDI: 00007f787067fbf0
>> > RBP: 0000000000000001 R08: 00000000200000c0 R09: 0000000020000080
>> > R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000014
>> > R13: 0000000000000001 R14: 0000000000700008 R15: 0000000000000043
>> > ------------[ cut here ]------------
>> > kernel BUG at fs/btrfs/volumes.c:1032!
>> > invalid opcode: 0000 [#1] SMP KASAN
>> > CPU: 1 PID: 22303 Comm: syz-executor1 Not tainted 4.17.0+ #86
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> > Google 01/01/2011
>> > RIP: 0010:btrfs_prepare_close_one_device fs/btrfs/volumes.c:1032 [inline]
>>
>> btrfs_prepare_close_one_device()
>> ::
>> 1031           name = rcu_string_strdup(device->name->str, GFP_NOFS);
>> 1032           BUG_ON(!name); /* -ENOMEM */
>>
>> The way we close our devices needs new memory allocations
>> at the time of device close. By doing this apart from the BUG_ON
>> reported here, there _were_ other complications like managing the sysfs
>> links and moving them to the newly allocated btrfs_fs_devices.
>> So sometime back I attempted to correct this approach to a simple
>> device close without fresh allocation, however it wasn't successful.
>> I am going to try that again, but its not p1.
>
> Yeah, getting rid of the allocations while freeing device would be great
> but unfortunatelly is not simple.
>
> Normally the GFP_NOFS allocations do not fail so I think the fuzzer
> environment is tuned to allow that, which is fine for coverage but does
> not happen in practice. This will be fixed eventually.

Isn't GFP_NOFS more restricted than normal allocations? Are these
allocations accounted against memcg? It's easy to fail any allocation
within a memory container.
