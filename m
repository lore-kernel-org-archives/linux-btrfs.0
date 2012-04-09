From: David Sterba <dave@jikos.cz>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Tue, 10 Apr 2012 01:19:54 +0200
Message-ID: <20120409231954.GC11041@twin.jikos.cz>
References: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
 <4F82F5BA.3080504@kraav.com>
 <CAMVG2styuLG9ai0rb20jf=pwnAA3XU3zZsL5PfmxoMXYajG9BQ@mail.gmail.com>
 <4F834D75.5060703@kraav.com>
 <4F835550.6090106@kraav.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel J Blueman <daniel@quora.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>, idryomov@gmail.com
To: Leho Kraav <leho@kraav.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F835550.6090106@kraav.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 12:32:00AM +0300, Leho Kraav wrote:
> It is also BUG time WITH the patch. Mount succeeds, but "btrfs fi balance
> HOME" gives us:
> 
> Apr 10 00:24:18 server sudo: pam_unix(sudo:session): session opened for user > root by (uid=1000)
> Apr 10 00:24:18 server kernel: [  363.839105] ------------[ cut here > ]------------
> Apr 10 00:24:18 server kernel: [  363.839163] kernel BUG at > fs/btrfs/volumes.c:2733!

that's

2732         if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
2733                 BUG_ON(ret == -EEXIST);
^^^^
2734                 set_balance_control(bctl);
2735         } else {
2736                 BUG_ON(ret != -EEXIST);
2737                 spin_lock(&fs_info->balance_lock);
2738                 update_balance_args(bctl);
2739                 spin_unlock(&fs_info->balance_lock);
2740         }

IIRC somebody reported similar problem recently. It basically means
there's an inconsistent balance state. Adding Ilya to CC.


david
