From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: Free free_space item properly in btrfs_trim_block_group()
Date: Wed, 20 Apr 2011 08:02:56 -0400
Message-ID: <1303300962-sup-8386@think>
References: <4DAE9B53.7090504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	lidongyang <lidongyang@novell.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DAE9B53.7090504@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-04-20 04:37:39 -0400:
> Since commit dc89e9824464e91fa0b06267864ceabe3186fd8b, we've changed
> to use a specific slab for alocation of free_space items.

Oh, nice catch.  Thanks!

-chris
