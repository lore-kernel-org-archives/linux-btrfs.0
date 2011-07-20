From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: initial online fsck support
Date: Wed, 20 Jul 2011 11:06:51 -0400
Message-ID: <1311174334-sup-9998@shiny>
References: <4E0C4303.1080406@cn.fujitsu.com> <m239ipnb7v.fsf@firstfloor.org> <201107021347.42281.hka@qbs.com.pl> <20110702170443.GI23059@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>, Li Zefan <lizf@cn.fujitsu.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110702170443.GI23059@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andi Kleen's message of 2011-07-02 13:04:43 -0400:
> > The two big features of btrfs are self-healing and online fsck, those have to 
> 
> Are they?
> 
> > be implemented in kernel space.
> 
> Why? There have been online fscks in user space in the past,
> e.g. the various schemes using LVM snapshots for ext* and 
> other related work on the BSD FFS. I don't see any principal
> reason why it couldn't be done for btrfs either.
> 
> A good fsck is quite complex and you are unlikely to want all
> that code in kernel space.

The offline fsck for btrfs is basically for repairing the worst possible
problems (things that make the FS unmountable).

The online code can easily take on smaller things, like detecting
incorrect link counts and a whole series of other problems that
shouldn't require offline access.

-chris
