Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932400AbeCLTKU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 15:10:20 -0400
Date: Mon, 12 Mar 2018 20:07:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Axel Burri <axel@tty0.ch>
Cc: Tomasz Pala <gotar@polanet.pl>, linux-btrfs@vger.kernel.org
Subject: Re: [btrfs-progs] coreutils-like -i parameter, splitting permissions
 for various tasks
Message-ID: <20180312190757.GF32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180210112441.GA25166@polanet.pl>
 <45c8f8bd-3372-a1f6-63b9-4679710356ff@tty0.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45c8f8bd-3372-a1f6-63b9-4679710356ff@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 11, 2018 at 08:04:39PM +0100, Axel Burri wrote:
> 
> 
> On 2018-02-10 12:24, Tomasz Pala wrote:
> > There is a serious flaw in btrfs subcommands handling. Since all of them
> > are handled by single 'btrfs' binary, there is no way to create any
> > protection against accidental data loss for (the only one I've found,
> > but still DANGEROUS) 'btrfs subvolume delete'.
> > 
> > There are several protections that are being used for various commands.
> > For example, with zsh having hist_ignore_space enabled I got:
> > 
> > alias kill=' kill'
> > alias halt=' halt'
> > alias init=' init'
> > alias poweroff=' poweroff'
> > alias reboot=' reboot'
> > alias shutdown=' shutdown'
> > alias telinit=' telinit'
> > 
> > so that these command are never saved into my shell history.
> > 
> > Other system-wide protection enabled by default might be coreutils.sh
> > creating aliases:
> > 
> > alias cp=' cp --interactive --archive --backup=numbered --reflink=auto'
> > alias mv=' mv --interactive --backup=numbered'
> > alias rm=' rm --interactive --one-file-system --interactive=once'
> > 
> > All such countermeasures reduce the probability of fatal mistakes.
> > 
> > 
> > There is no 'prompt before doing ANYTHING irreversible' option for btrfs,
> > so everyone needs to take special care typing commands. Since snapshotting
> > and managing subvolumes is some daily-routine, not anything special
> > (like creating storage pools or managing devices), this should be more
> > forgiving for any user errors. Since there is no other (obvious)
> > solution, I propose makeing "subvolume delete" ask for confirmation by
> > default, unless used with newly introduced option, like -y(--yes).
> > 
> > 
> > Moreover, since there might be different admin roles on the system, the
> > btrfs-progs should be splitted into separate tools, so one could have
> > quota-admin without permissions for managing devices, backup-admin
> > with access to all the subvolumes or maintenance-admin that could issue
> > scrub or rebalance volumes. For backward compatibility, these tools
> > could be issued by 'btrfs' wrapper binary.
> 
> FWIW, I maintain a little patchset on btrfs-progs which separates
> specific btrfs command groups and thus can be used to set/restrict
> privileged access:
> 
> https://github.com/digint/btrfs-progs-btrbk
> 
> It's far from being complete, merely an ugly hack. I use it to constrain
> btrfs actions (issued by btrbk) on remote machines within cron jobs.

I think this is an interesting approach, the specific binaries with
capabilities avoid setting up sudo. The sources can also be generated
from some template, but what you have now is fine. I'm a bit concerned
about the security implications as the tools would need to be limited to
trusted users and up to the admin to deploy them properly, but otherwise
I see the usecase and would not mind merging it.
