Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2HONMH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 09:12:07 -0400
Date: Wed, 15 Aug 2012 15:12:04 +0200
From: Jan Kara <jack@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, liub.liubo@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] Btrfs: fix deadlock between sys_sync and freeze
Message-ID: <20120815131204.GE29223@quack.suse.cz>
References: <1344920474-10014-1-git-send-email-liub.liubo@gmail.com>
 <502A4BB2.6000404@gmail.com>
 <502A5849.9040602@oracle.com>
 <502A5CDA.2080806@gmail.com>
 <502B9B45.5070304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502B9B45.5070304@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 15-08-12 20:51:17, Liu Bo wrote:
> (CCed Jan, the author of freeze code)
> On 08/14/2012 10:12 PM, Marco Stornelli wrote:
> > Il 14/08/2012 15:53, Liu Bo ha scritto:
> >> On 08/14/2012 08:59 PM, Marco Stornelli wrote:
> >>> Il 14/08/2012 07:01, liub.liubo@gmail.com ha scritto:
> >>>> From: Liu Bo <bo.li.liu@oracle.com>
> >>>>
> >>>> I found this while testing xfstests 068, the story is
> >>>>
> >>>>       t1                                            t2
> >>>>     sys_sync                                    thaw_super
> >>>>       iterate_supers
> >>>>         down_read(sb->s_umount)                   down_write(sb->s_umount) --->wait for t1
> >>>>         sync_fs (with wait mode)
> >>>>           start_transaction
> >>>>             sb_start_intwrite --------------------> wait for t2 to set s_writers.frozen to SB_UNFROZEN
> >>>>
> >>>> In this patch, I add an helper sb_start_intwrite_trylock() and use it before we
> >>>> start_transaction in sync_fs() with wait mode so that we won't hit the deadlock.
> >>>>
> >>>
> >>> IMHO, we should avoid to call the sync operation on a frozen fs. The freeze operation, indeed, already include a sync operation.
> >>> According to man page, no other operation should modify the fs after the freeze.
> >>> So for me the modification is inside sync_filesystem (and sync_one_sb).
> >>
> >> Do you mean that we should add the trylock check in sync_filesystem?
> >>
> >> But it seems to be useless because we already run into down_read(sb->s_umount) before starting sync_one_sb().
> >>
> >> thanks,
> >> liubo
> >>
> > 
> > I meant that we should check if there are in a "complete" freeze state (according to the "states" of a freeze transaction) and simply skip the sync operation.
> > 
> 
> I'm ok with it.
> 
> What do you think about it, Jan?  Any comments?
  Hum, so what I don't exactly understand is why does btrfs start a
transaction in ->sync_fs(). The idea of freeze code is that when filesystem
is frozen, there is no data / metadata to write and thus we avoid deadlocks
arising from trying to write anything with s_umount held.

So checking whether filesystem is frozen and avoiding transaction start in
that case in btrfs_sync_fs() will work but looks hacky. Rather the check
should be for the thing which is the reason for transaction start-end pair
in btrfs_sync_fs(). My naive guess would be we should check whether there
is any transaction running...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
