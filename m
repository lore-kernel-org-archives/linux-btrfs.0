Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38959 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3CKKUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 06:20:20 -0400
Message-ID: <513DAFDF.2040805@petaramesh.org>
Date: Mon, 11 Mar 2013 11:20:15 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
CC: Roman Mamedov <rm@romanrm.ru>, Michael Johnson - MJ <mj@revmj.com>
Subject: Re: snapshot deletion / unmount slowness
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com> <20130311121143.5cfa69d8@natsu> <20130311064749.GA28468@liubo.jp.oracle.com>
In-Reply-To: <20130311064749.GA28468@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 11/03/2013 07:47, Liu Bo a écrit :
> A recent commit(commit fa6ac8765c48a06dfed914e8c8c3a903f9d313a0
> Btrfs: fix cleaner thread not working with inode cache option)
> may improve the situation.

Hi Liu,

I have never seen this issue with btrfs-cleaner not working, when I
delete snapshots it typically kicks in a few seconds later and works
"until done".

Does the bug you mention affect only specific kernel versions ?

AFAIK I use inode_cache (it's not in my fstab but I mounted my FSes
using it manually, and I believe it's a "persistent" option ? - I may
possibly be wrong...)

TIA

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

