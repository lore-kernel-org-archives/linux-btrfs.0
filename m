Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaLQQt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 11:49:26 -0500
Date: Wed, 17 Dec 2014 17:49:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Merlijn Wajer <merlijn@wizzup.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs-progs: Support for musl libc (and perhaps also
 uclibc)
Message-ID: <20141217164924.GB27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <548C4E9D.2080309@wizzup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <548C4E9D.2080309@wizzup.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 13, 2014 at 03:35:09PM +0100, Merlijn Wajer wrote:
[snip]

> Attached are the two patches generated with git format-patch. I am aware
> that this may not be required format for submitting patches -- but
> please give me some time to get used to the etiquette. :-)

Thanks, there are minor things that I won't bother to point out to
occasional contributors and fix them myself. The only formal requirement
is the Signed-off-by tag, you can find the description eg. here

http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L358

> Please let me know if musl-libc (or any other libc) is a supported
> platform, and if so, if and how I can improve on said patches.

I'm not aware of non-glibc users, but I don't see any problem to add
support for more libc implementations. However, I won't regularly verify
that it builds so it might break.

Seems that only standardized library calls are used in btrfs-progs so
any kind of support is probably going to be satisfied by #ifdefs.

Your patches are simple so I'll try to schedule them to some 3.18.x
update.
