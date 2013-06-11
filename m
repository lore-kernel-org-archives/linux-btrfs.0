Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab3FKVEm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 17:04:42 -0400
Date: Tue, 11 Jun 2013 14:04:40 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@redhat.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v2
Message-ID: <20130611210440.GC29353@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de> <51B78F1B.7000100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51B78F1B.7000100@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 10:56:59PM +0200, Gabriel de Perthuis wrote:
> > What I found however is that neither of these is a great idea ;)
> > 
> > - We want to require that the inode be open for writing so that an
> >   unprivileged user can't do things like run dedupe on a performance
> >   sensitive file that they might only have read access to.  In addition I
> >   could see it as kind of a surprise (non-standard behavior) to an
> >   administrator that users could alter the layout of files they are only
> >   allowed to read.
> > 
> > - Readonly snapshots won't let you open for write anyway (unsuprisingly,
> >   open() returns -EROFS).  So that kind of kills the idea of them being able
> >   to open those files for write which we want to dedupe.
> > 
> > That said, I still think being able to run this against a set of readonly
> > snapshots makes sense especially if those snapshots are taken for backup
> > purposes. I'm just not sure how we can sanely enable it.
> 
> The check could be: if (fmode_write || cap_sys_admin).
> 
> This isn't incompatible with mnt_want_write, that check is at the
> level of the superblocks and vfsmount and not the subvolume fsid.

Oh ok that's certainly better. I think we still have a problem though - how
does a process gets write access to a file from a ro-snapshot? If I open a
file (as root) on a ro-snapshot on my test machine here I'll get -EROFS.

I'm a bit confused - how does mnt_want_write factor in here? I think that's
for a totally seperate kind of accounting, right?

Thanks for the quick reply :)
	--Mark

--
Mark Fasheh
