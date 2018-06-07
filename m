Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932987AbeFGQzA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 12:55:00 -0400
Date: Thu, 7 Jun 2018 18:52:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        syzbot <syzbot+5b658d997a83984507a6@syzkaller.appspotmail.com>,
        clm@fb.com, dsterba@suse.com, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:LINE!
Message-ID: <20180607165213.GI3215@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <00000000000096009b056df92dc1@google.com>
 <70a3c2d1-3f53-d4c0-13b3-29f836ec46d9@oracle.com>
 <20180607153450.GF3215@twin.jikos.cz>
 <CACT4Y+arBwkwhD-kob9fg1pVBXiMepW6KBK2LkhwjQ9HnDcoqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACT4Y+arBwkwhD-kob9fg1pVBXiMepW6KBK2LkhwjQ9HnDcoqw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 07, 2018 at 06:28:02PM +0200, Dmitry Vyukov wrote:
> > Normally the GFP_NOFS allocations do not fail so I think the fuzzer
> > environment is tuned to allow that, which is fine for coverage but does
> > not happen in practice. This will be fixed eventually.
> 
> Isn't GFP_NOFS more restricted than normal allocations?  Are these
> allocations accounted against memcg? It's easy to fail any allocation
> within a memory container.

https://lwn.net/Articles/723317/ The 'too small to fail' and some
unwritten semantics of GFP_NOFS but I think you're right about the
memory controler that can fail any allocation though.

Error handling is being improved over time, the memory allocation
failures are in some cases hard and this one would need to update some
logic so it's not a oneliner.
