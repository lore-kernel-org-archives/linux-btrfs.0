Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34212 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3FFOc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jun 2013 10:32:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6A9F79A033F
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Jun 2013 08:32:29 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: "dsterba@suse.cz" <dsterba@suse.cz>, David Sterba <dsterba@suse.cz>,
        Miao Xie <miaox@cn.fujitsu.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130606135550.GG18160@twin.jikos.cz>
CC: "dsterba@suse.cz" <dsterba@suse.cz>, Zach Brown <zab@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
 <20130604232657.GE24721@lenny.home.zabbo.net>
 <51AEA3A0.4050203@cn.fujitsu.com> <20130605133636.GA18160@twin.jikos.cz>
 <51AFE74B.8090509@cn.fujitsu.com> <20130606135550.GG18160@twin.jikos.cz>
Message-ID: <20130606143227.4088.53583@localhost.localdomain>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Thu, 6 Jun 2013 10:32:27 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-06-06 09:55:50)
> On Thu, Jun 06, 2013 at 09:35:07AM +0800, Miao Xie wrote:
> > On    wed, 5 Jun 2013 15:36:36 +0200, David Sterba wrote:
> > > On Wed, Jun 05, 2013 at 10:34:08AM +0800, Miao Xie wrote:
> > >> On         tue, 4 Jun 2013 16:26:57 -0700, Zach Brown wrote:
> > >>> On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> > >>>> Quoting Zach Brown (2013-06-04 18:17:54)
> > >>>>> Hi gang,
> > >>>>>
> > >>>>> I finally sat down to fix that readdir hang that has been in the back
> > >>>>> of my mind for a while.  I *hope* that the fix is pretty simple: just
> > >>>>> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > >>>>> indicator that we shouldn't return entries.  Does this look reasonable?
> > >>>>
> > >>>> I like it, and it doesn't look too far away from how others are abusing
> > >>>> f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> > >>>> loves to surprise me.
> > >>>
> > >>> Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)
> > >>
> > >> If we can not use f_version, we can use private_data. I think this variant is
> > >> safe.
> > > 
> > > private_data is used within the ioctl user transactions, so a
> > > readdir(mountpoint) with a user transaction running can break it.
> > 
> > don't worry, we can allocate a structure to keep both transaction handle and the information
> > of readdir, just like ext3/ext4. It is a flexible way and we can extend the structure to keep
> > more information if need in the future.
> > 
> > Beside the above method, we also can abuse the low bits of private_data to indicator that
> > we shouldn't return entries.
> 
> Allocating a full structure for private_data sounds better than directly
> modifying the pointer value itself.

I'd actually rather tag the pointers than go through kmalloc, we just
need one bit (maybe that really just shows how badly we've corrupted
poor Miao).  But, we're not there yet, I think Zach's initial patch will
work fine.

-chris

