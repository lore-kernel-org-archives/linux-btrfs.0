Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaAOQkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 11:40:40 -0500
Date: Wed, 15 Jan 2014 17:40:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Btrfs: fix protection between send and root
 deletion
Message-ID: <20140115164038.GD6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20140113182745.GS6498@twin.jikos.cz>
 <52D49F80.6020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D49F80.6020604@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 14, 2014 at 10:22:56AM +0800, Miao Xie wrote:
> On mon, 13 Jan 2014 19:27:45 +0100, David Sterba wrote:
> The root what is about to be sent out may be deleted after we get it, if
> there is no in-memory i-node in it, it will be inserted into the dead_roots list
> immediately, then the cleaner thread will drop it. But the sender doesn't know,
> the sender will access a broken tree.

Thanks, I see the race now, but I think that we should prevent the
subvolume deletion at a higher level, similar to the RO->RW protection.

Your fix makes sure that the deleted root will not get cleaned and stays
during the send. Only after it finishes it will be cleaned. Now, what if
send fails or is interrupted? There's no way to redo it. Yes the user
can be blamed for the mistake, or the tools will prevent him to do it.

I see the latter as more user-friendly. Doing a 'send and forget' where
I don't care if the data will be sent properly does not fit the primary
purpose of send/receive with backups.

My idea to fix that:
- add an internal root_item flag to denote a dead root
- set this flag in btrfs_add_dead_root()
- check the flag in send similar to the btrfs_root_readonly checks, for
  all involved roots
- in 'destroy subvolume, check if the send_in_progress is set and refuse
  to delete

The root lookup in send via btrfs_read_fs_root_no_name will check if the
root is dead or not. If it is, ENOENT, aborted send. If it's alive, it's
protected by send_in_progress, send can continue.

This has become more complex than the original patch, I'll try to think
about it again later if it still makes sense. Comments welcome of course.


david
