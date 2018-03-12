Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39389 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbeCLTAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 15:00:19 -0400
Date: Mon, 12 Mar 2018 19:57:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [btrfs-progs] coreutils-like -i parameter, splitting permissions
 for various tasks
Message-ID: <20180312185756.GE32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180210112441.GA25166@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180210112441.GA25166@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 10, 2018 at 12:24:41PM +0100, Tomasz Pala wrote:
> There is a serious flaw in btrfs subcommands handling. Since all of them
> are handled by single 'btrfs' binary, there is no way to create any
> protection against accidental data loss for (the only one I've found,
> but still DANGEROUS) 'btrfs subvolume delete'.

So, what about this:

we can add a global option to add the requested interactivity and
commands that are considred dangerous will require the confimation.

alias btrfs='btrfs -i'

This would expand to 'btrfs -i subvolume delete /subvol' etc. For any
command that is not dangerous, the option -i will be accepted but
nothing would happen.

[...]
> (like creating storage pools or managing devices), this should be more
> forgiving for any user errors. Since there is no other (obvious)
> solution, I propose makeing "subvolume delete" ask for confirmation by
> default, unless used with newly introduced option, like -y(--yes).

Does it make sense to add an option to override the -i? This would
cancel the -i that would be hidden in the alias. This can be generally
done by quoting the command, but the option to override -i might fit
somebodys usability habits.

Either option to 'say yes to all queries' or a simple negation of -i,
like -I.
