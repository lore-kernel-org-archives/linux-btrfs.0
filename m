From: jim owens <jowens@hp.com>
Subject: Re: Btrfs for mainline
Date: Thu, 08 Jan 2009 15:15:01 -0500
Message-ID: <49665EC5.2090707@hp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231270893.4888.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Ryusuke Konishi <ryusuke@osrg.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762915AbZAHUP5@vger.kernel.org>
In-Reply-To: <1231270893.4888.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> 
> Unresolved from this reviewing thread:
> 
> * Should it be named btrfsdev?  My vote is no, it is extra work for the
> distros when we finally do rename it, and I don't think btrfs really has
> the reputation for stability right now.  But if Linus or Andrew would
> prefer the dev on there, I'll do it.

We know who has the last word on this.

This is just additional background for those who commented.

Using tricks such as btrfsdev, mount "unsafe", or kernel
messages won't provide a guarantee that btrfs is only used
in appropriate and risk-free ways.  Those tricks also won't
prevent all problems caused by booting a broken old (or new)
release.  And the perceived quality and performance of any
filesystem release, even between stable versions, depends
very much on individual system configuration and use.

Before Chris posted the code, we had some btrfs concall
discussions about the best way to set user expectations on
btrfs mainline 1.0.  Consensus was that the best way we
could do this was to warn them when they did mkfs.btrfs.

Today I sent a patch to Chris (which he may ignore/change)
so mkfs.btrfs will say:

WARNING! - Btrfs v0.16-39-gf9972b4 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

with a blank line before and after.  They don't have to
confirm since they can just mkfs a different filesystem
if I scared them away.  The version is auto-generated.

jim
