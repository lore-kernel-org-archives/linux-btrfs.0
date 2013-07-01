Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52945 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3GANSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 09:18:23 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CEDF99A04E9
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 07:18:22 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, Zach Brown <zab@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130701125435.GE4288@localhost.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130701125435.GE4288@localhost.localdomain>
Message-ID: <20130701131820.14981.35433@localhost.localdomain>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Mon, 1 Jul 2013 09:18:20 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-07-01 08:54:35)
> On Tue, Jun 04, 2013 at 06:17:54PM -0400, Zach Brown wrote:
> > Hi gang,
> > 
> > I finally sat down to fix that readdir hang that has been in the back
> > of my mind for a while.  I *hope* that the fix is pretty simple: just
> > don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > indicator that we shouldn't return entries.  Does this look reasonable?
> > 
> > We still have the problem that we can generate valid large f_pos values
> > that can confuse 32bit userspace, but that's a different problem.  I
> > think we'll want filldir generation of EOVERFLOW like what exists for
> > large inodes. 
> > 
> > The rest of the patches are cleanups that I saw when absorbing the
> > code.  It's all lightly tested with xfstests but it wouldn't surprise
> > me if I missed something so review is appreciated.
> > 
> > Thanks!
> > 
> 
> One of these patches is making new entries not show up in readdir.  This was
> discovered while running stress.sh overnight, it complained about files not
> matching but when they were checked the files matched.  Dropping the entire
> series made stress.sh run fine.  So I'm dropping these for the next merge window
> but I'll dig into it and try and figure out what was causing the problem.

Unfortunately I've only triggered this on flash, and the run takes about
two hours to trigger.  Trying now with some extra printks to see if I
can nail it down

-chris

