Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaIBLFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:05:03 -0400
Date: Tue, 2 Sep 2014 13:05:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cancel scrub/replace if the user space process
 receive SIGKILL.
Message-ID: <20140902110502.GC5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407317662-9364-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407317662-9364-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 06, 2014 at 05:34:22PM +0800, Qu Wenruo wrote:
> When impatient sysadmin is tired of waiting background running btrfs
> scrub/replace and send SIGKILL to btrfs process, unlike
> SIGINT/SIGTERM which can be caught by user space program and cancel the
> scrub work, user space program will continue running until ioctl exits.

I don't understand why it's needed to add another way to cancel scrub.
Does it mean that 'btrfs scrub cancel' is not sufficient? It cancels
both foreground and background scrub.  Same for dev-replace, it has the
cancel subcommand.

Sending KILL signal to some random process is not the right way, how can
the admin know to which filesystem the process belongs?

> To keep it consistent with the behavior of btrfs-progs, which cancels
> the work when SIGINT is received, this patch will make scrub routine to
> check SIGKILL pending of current task and cancel the work if SIGKILL is
> already pending.

The foreground scrub starts a separate process and then wait()s. If you
want to catch a SIGINT, then change it to a loop that checks for if the
forked process exited or if Ctrl-c was pressed.

The dev-replace can be started without a userspace process via
kthread_run from btrfs_dev_replace_continue_on_mount, and sending
signals to kernel processes requires some caution. For one, the signals
have to be explicitly allowed. But before that I'd like to better
understand where the SIGKILL is unavoidable.

Thanks.
