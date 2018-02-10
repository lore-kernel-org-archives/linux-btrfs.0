Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:43309 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbeBJLYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Feb 2018 06:24:43 -0500
Date: Sat, 10 Feb 2018 12:24:41 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: [btrfs-progs] coreutils-like -i parameter, splitting permissions
 for various tasks
Message-ID: <20180210112441.GA25166@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a serious flaw in btrfs subcommands handling. Since all of them
are handled by single 'btrfs' binary, there is no way to create any
protection against accidental data loss for (the only one I've found,
but still DANGEROUS) 'btrfs subvolume delete'.

There are several protections that are being used for various commands.
For example, with zsh having hist_ignore_space enabled I got:

alias kill=' kill'
alias halt=' halt'
alias init=' init'
alias poweroff=' poweroff'
alias reboot=' reboot'
alias shutdown=' shutdown'
alias telinit=' telinit'

so that these command are never saved into my shell history.

Other system-wide protection enabled by default might be coreutils.sh
creating aliases:

alias cp=' cp --interactive --archive --backup=numbered --reflink=auto'
alias mv=' mv --interactive --backup=numbered'
alias rm=' rm --interactive --one-file-system --interactive=once'

All such countermeasures reduce the probability of fatal mistakes.


There is no 'prompt before doing ANYTHING irreversible' option for btrfs,
so everyone needs to take special care typing commands. Since snapshotting
and managing subvolumes is some daily-routine, not anything special
(like creating storage pools or managing devices), this should be more
forgiving for any user errors. Since there is no other (obvious)
solution, I propose makeing "subvolume delete" ask for confirmation by
default, unless used with newly introduced option, like -y(--yes).


Moreover, since there might be different admin roles on the system, the
btrfs-progs should be splitted into separate tools, so one could have
quota-admin without permissions for managing devices, backup-admin
with access to all the subvolumes or maintenance-admin that could issue
scrub or rebalance volumes. For backward compatibility, these tools
could be issued by 'btrfs' wrapper binary.

-- 
Tomasz Pala <gotar@pld-linux.org>
