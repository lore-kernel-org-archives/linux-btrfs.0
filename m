Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbaAUSQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 13:16:29 -0500
Date: Tue, 21 Jan 2014 19:16:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Btrfs: fix protection between send and root
 deletion
Message-ID: <20140121181626.GC6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <20140113182745.GS6498@twin.jikos.cz>
 <52D49F80.6020604@cn.fujitsu.com>
 <20140115164038.GD6498@twin.jikos.cz>
 <52D744C6.7040006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52D744C6.7040006@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 10:32:38AM +0800, Miao Xie wrote:
> > Your fix makes sure that the deleted root will not get cleaned and stays
> > during the send. Only after it finishes it will be cleaned. Now, what if
> > send fails or is interrupted? There's no way to redo it. Yes the user
> > can be blamed for the mistake, or the tools will prevent him to do it.
> 
> I don't think so. The users should be responsible for their behavior if they
> destroy the subvolume.

Right now it's not possible to determine if a subvolume is involved in a
send (other than the user knows by himself that he started send). Send
or subvolume cleaning can be performed on the background. Although the
user is responsible for his actions, the consequence here is not
obvious, silent and irreversible.

> > I see the latter as more user-friendly. Doing a 'send and forget' where
> > I don't care if the data will be sent properly does not fit the primary
> > purpose of send/receive with backups.
> > 
> > My idea to fix that:
> > - add an internal root_item flag to denote a dead root
> > - set this flag in btrfs_add_dead_root()
> > - check the flag in send similar to the btrfs_root_readonly checks, for
> >   all involved roots
> > - in 'destroy subvolume, check if the send_in_progress is set and refuse
> >   to delete
> 
> It is similar to our approach. But I think our idea is better because
> - we needn't add a new flag

Adding the flag is cheap.

> - The subvolumes are special directory, the most operations of them should
>   be similar to the common directory. Since we can remove a directory while
>   someone is accessing it, it is better that we can destroy a subvolume
>   while we are using it as a send parent.

Yes they're similar, but subvolumes have additional features that need
to be handled appropriately. One cannot send a directory.

So we disagree, I see a reason for the deletion protection and will do
the patch myself. Let's see if we can get more user feedback then.

I'm NAKing this patch in current state, if it helps anything.


david
