From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: initial online fsck support
Date: Sat, 2 Jul 2011 19:04:43 +0200
Message-ID: <20110702170443.GI23059@one.firstfloor.org>
References: <4E0C4303.1080406@cn.fujitsu.com> <m239ipnb7v.fsf@firstfloor.org> <201107021347.42281.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107021347.42281.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

> The two big features of btrfs are self-healing and online fsck, those have to 

Are they?

> be implemented in kernel space.

Why? There have been online fscks in user space in the past,
e.g. the various schemes using LVM snapshots for ext* and 
other related work on the BSD FFS. I don't see any principal
reason why it couldn't be done for btrfs either.

A good fsck is quite complex and you are unlikely to want all
that code in kernel space.

-Andi
