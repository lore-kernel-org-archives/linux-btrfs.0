Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933708AbeFGPhh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 11:37:37 -0400
Date: Thu, 7 Jun 2018 17:34:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>, clm@fb.com,
        dsterba@suse.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
Message-ID: <20180607153450.GF3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <00000000000096009b056df92dc1@google.com>
 <70a3c2d1-3f53-d4c0-13b3-29f836ec46d9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <70a3c2d1-3f53-d4c0-13b3-29f836ec46d9@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 12:15:04AM +0800, Anand Jain wrote:
> 
> 
> On 06/06/2018 09:31 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    af6c5d5e01ad Merge branch 'for-4.18' of 
> > git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15f700af800000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=12ff770540994680
> > dashboard link: 
> > https://syzkaller.appspot.com/bug?extid=5b658d997a83984507a6
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com
> > 
> > RDX: 0000000020000080 RSI: 0000000020000040 RDI: 00007f787067fbf0
> > RBP: 0000000000000001 R08: 00000000200000c0 R09: 0000000020000080
> > R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000014
> > R13: 0000000000000001 R14: 0000000000700008 R15: 0000000000000043
> > ------------[ cut here ]------------
> > kernel BUG at fs/btrfs/volumes.c:1032!
> > invalid opcode: 0000 [#1] SMP KASAN
> > CPU: 1 PID: 22303 Comm: syz-executor1 Not tainted 4.17.0+ #86
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> > Google 01/01/2011
> > RIP: 0010:btrfs_prepare_close_one_device fs/btrfs/volumes.c:1032 [inline]
> 
> btrfs_prepare_close_one_device()
> ::
> 1031           name = rcu_string_strdup(device->name->str, GFP_NOFS);
> 1032           BUG_ON(!name); /* -ENOMEM */
> 
> The way we close our devices needs new memory allocations
> at the time of device close. By doing this apart from the BUG_ON
> reported here, there _were_ other complications like managing the sysfs
> links and moving them to the newly allocated btrfs_fs_devices.
> So sometime back I attempted to correct this approach to a simple
> device close without fresh allocation, however it wasn't successful.
> I am going to try that again, but its not p1.

Yeah, getting rid of the allocations while freeing device would be great
but unfortunatelly is not simple.

Normally the GFP_NOFS allocations do not fail so I think the fuzzer
environment is tuned to allow that, which is fine for coverage but does
not happen in practice. This will be fixed eventually.
