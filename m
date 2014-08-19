Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaHSODM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 10:03:12 -0400
Date: Tue, 19 Aug 2014 16:03:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs-progs: Move btrfstune to btrfs device tune
Message-ID: <20140819140309.GT1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53E80B87.30504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E80B87.30504@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 03:17:11AM +0300, Timofey Titovets wrote:
> According to https://btrfs.wiki.kernel.org/index.php/Project_ideas#btrfs
> Quote:
> merge functionality of btrfstune, eg. under btrfs dev set-seed /dev/
> (discuss the command name though)

I've added this project idea long time ago and I'm afraid it's not valid
anymore, at least not in the proposed way.

> This patch is just code move
> After, user can tune btrfs parameters through:
> btrfs dev tune -xr /dev/sda2

The btrfstune utility works on an unmounted filesystem and affects the
whole filesystem, so the 'device' subgroup is not right here.

Most of the commands from the base utility on a mounted filesystem, so a
separate btrfstune makes some distinction. The reason for merging the
two was to avoid a 1MB binary for very simple thing, the generic
filesystem code can be shared with 'btrfs'.

The question is what's the right UI, a new subcommand, or via the
generic properties command? The property interface is not yet populated,
so it might be hard to imagine where the tuning settings would go.
Something like this:

$ btrfs prop set feature.skinny-metadata 1 /dev/sdx

The extended refs can be turned on even on a mounted filesystem, so this
would avoid doing 'echo 1 > /sys/fs/btrfs/UUID/features/extended_iref'.

At this moment I'm inclined to use the properties interface, which means
that the btrfstune utility will stay a bit longer. I'll update the
project idea to reflect this so it's not confusing anymore (sorry).
