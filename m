From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Btrfs Kernel Oops on Full Volume
Date: Thu, 4 Feb 2010 22:14:15 -0600
Message-ID: <26a1f7961002042014u69b03b4cue48861cffe43b1ab@mail.gmail.com>
References: <26a1f7961002041506v75ce7610s356dd42ffca1c9b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <26a1f7961002041506v75ce7610s356dd42ffca1c9b5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Some quick follow-up.

I pulled the most recent patches pushed to the git repository today,
backported them to my 2.6.32 kernel, and repeated the operation.

I received the same kernel Oops:
[ 1113.667345] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[ 1113.667348] IP: [<c124a475>] btrfs_print_leaf+0xe/0x6e3
[ 1113.667354] *pde = 00000000
[ 1113.667357] Oops: 0000 [#1]
