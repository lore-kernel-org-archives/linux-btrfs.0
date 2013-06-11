Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab3FKVpJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 17:45:09 -0400
Date: Tue, 11 Jun 2013 14:45:06 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@redhat.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v2
Message-ID: <20130611214506.GD29353@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de> <51B78F1B.7000100@gmail.com> <20130611210440.GC29353@wotan.suse.de> <51B7973D.3080301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51B7973D.3080301@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 11:31:41PM +0200, Gabriel de Perthuis wrote:
> Le 11/06/2013 23:04, Mark Fasheh a écrit :
> > On Tue, Jun 11, 2013 at 10:56:59PM +0200, Gabriel de Perthuis wrote:
> >>> What I found however is that neither of these is a great idea ;)
> >>>
> >>> - We want to require that the inode be open for writing so that an
> >>>   unprivileged user can't do things like run dedupe on a performance
> >>>   sensitive file that they might only have read access to.  In addition I
> >>>   could see it as kind of a surprise (non-standard behavior) to an
> >>>   administrator that users could alter the layout of files they are only
> >>>   allowed to read.
> >>>
> >>> - Readonly snapshots won't let you open for write anyway (unsuprisingly,
> >>>   open() returns -EROFS).  So that kind of kills the idea of them being able
> >>>   to open those files for write which we want to dedupe.
> >>>
> >>> That said, I still think being able to run this against a set of readonly
> >>> snapshots makes sense especially if those snapshots are taken for backup
> >>> purposes. I'm just not sure how we can sanely enable it.
> >>
> >> The check could be: if (fmode_write || cap_sys_admin).
> >>
> >> This isn't incompatible with mnt_want_write, that check is at the
> >> level of the superblocks and vfsmount and not the subvolume fsid.
> > 
> > Oh ok that's certainly better. I think we still have a problem though - how
> > does a process gets write access to a file from a ro-snapshot? If I open a
> > file (as root) on a ro-snapshot on my test machine here I'll get -EROFS.
> 
> Your first series did work in that case.
> The process does get a read-only fd, but that's no obstacle for the ioctl.

Ahh, I had ignored the '||' in your check above. Basically though you have
to have write access unless you're the sysadmin, in which case open for
reading is enough. Makes sense -- I'll try this.
	--Mark

--
Mark Fasheh
