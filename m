From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Mon, 11 Apr 2011 14:29:21 +0800
Message-ID: <4DA29FC1.9050900@cn.fujitsu.com>
References: <20110402121946.6bf27f80@sf.home>	<4D96EE76.5040208@cn.fujitsu.com>	<20110402134132.0391f4fd@sf.home>	<4D9708E0.6030206@cn.fujitsu.com>	<20110402155545.2159043a@sf.home>	<4D9ECAF5.50108@cn.fujitsu.com>	<20110409000932.6154c7b5@sf>	<20110409001920.089c4409@sf> <20110409005555.4b136f25@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409005555.4b136f25@sf>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2011 05:55 AM, Sergei Trofimovich wrote:
> [  100.500011] Call Trace:
> [  100.500011]  [<ffffffff810ed3a0>] vfs_unlink+0x80/0xf0
> [  100.500011]  [<ffffffff810ef6f3>] do_unlinkat+0x173/0x1b0
> [  100.500011]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
> [  100.500011]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
> [  100.500011]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
> [  100.500011]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
> [  100.500011] Code: 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 0f 1f 40 00 4c 89 fe 4c 89 ef e8 05 d0 ff ff 85 c0 74 bb 0f 0b <0f> 0b 89 c3 eb cd 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 
> [  100.500011] RIP  [<ffffffffa024a011>] btrfs_unlink+0xd1/0xe0 [btrfs]
> [  100.500011]  RSP <ffff880070b55e28>
> [  100.525672] ---[ end trace 7e63b9144b7307fe ]---
> 
> Looks like I won't be able to test your patch until this thing will go away first.

Thanks a lot for testing, though.

I guess something messed up your btrfs metadata, cause when btrfs_unlink() wanted to remove A,
it found that A was just missing...

thanks,
liubo
