Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbaEMOWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 10:22:35 -0400
Date: Tue, 13 May 2014 16:22:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: =?utf-8?B?VG9tw6HFoSBQcnXFvmluYQ==?= <pruzinat@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
Message-ID: <20140513142234.GI6917@suse.cz>
Reply-To: dsterba@suse.cz
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
 <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
 <20140509145118.GD5988@twin.jikos.cz>
 <536D1AA6.7050407@libero.it>
 <20140512143946.GD6917@suse.cz>
 <5371105C.5030306@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5371105C.5030306@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 12, 2014 at 08:18:04PM +0200, Goffredo Baroncelli wrote:
> To be clear, I would like to avoid inode_cache on 64bit machine.
>
> In order to avoid the risk to exhaust the inode on 32bit and to be
> backward compatible with what already exists, we could add a flag to
> mkfs.btrfs to be only 64bit compatible and avoid inode_cache.

I thought about such bit as well but don't see a strong need for it, at
the moment the inode_cache is the only option that could prevent the
incompatibilities, but otherwise all features are designed to work on
32bits the same way as on 64bit.

So, my position here is not enforce anything, but document all the pros
and cons of the option and let the user decide.

Possibly, add more safety checks that would detect that a filesystem is
not safely mountable on 32bit. Eg. look for the highest inode num if
it's a 32bit system and inode_cache is not up-to-date, or warn early
that the inode space is running out.

> It it would be faster, I am sure that there are uses cases for that.
> 
> The major drawback that I see, is that it would be a code path less
> tested: I think that the 32bit system[*] would disappear soon

That's a valid point and for that reason I would not add more code.

> Finally I have a question: it is possible to disable inode_cache ?
> what means the flag "noinode_cache" ? It means disable the inode cache
> at all, or only avoid to store on disk the inode cache ?

The noinode_cache disables using the cache at runtime, it will be kept
on disk though (there's no "clear inode_cache" as for the space cache).
