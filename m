Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3FFNzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Jun 2013 09:55:54 -0400
Date: Thu, 6 Jun 2013 15:55:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Zach Brown <zab@redhat.com>,
        Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130606135550.GG18160@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
 <20130604232657.GE24721@lenny.home.zabbo.net>
 <51AEA3A0.4050203@cn.fujitsu.com>
 <20130605133636.GA18160@twin.jikos.cz>
 <51AFE74B.8090509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51AFE74B.8090509@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 06, 2013 at 09:35:07AM +0800, Miao Xie wrote:
> On 	wed, 5 Jun 2013 15:36:36 +0200, David Sterba wrote:
> > On Wed, Jun 05, 2013 at 10:34:08AM +0800, Miao Xie wrote:
> >> On 	tue, 4 Jun 2013 16:26:57 -0700, Zach Brown wrote:
> >>> On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> >>>> Quoting Zach Brown (2013-06-04 18:17:54)
> >>>>> Hi gang,
> >>>>>
> >>>>> I finally sat down to fix that readdir hang that has been in the back
> >>>>> of my mind for a while.  I *hope* that the fix is pretty simple: just
> >>>>> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> >>>>> indicator that we shouldn't return entries.  Does this look reasonable?
> >>>>
> >>>> I like it, and it doesn't look too far away from how others are abusing
> >>>> f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> >>>> loves to surprise me.
> >>>
> >>> Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)
> >>
> >> If we can not use f_version, we can use private_data. I think this variant is
> >> safe.
> > 
> > private_data is used within the ioctl user transactions, so a
> > readdir(mountpoint) with a user transaction running can break it.
> 
> don't worry, we can allocate a structure to keep both transaction handle and the information
> of readdir, just like ext3/ext4. It is a flexible way and we can extend the structure to keep
> more information if need in the future.
> 
> Beside the above method, we also can abuse the low bits of private_data to indicator that
> we shouldn't return entries.

Allocating a full structure for private_data sounds better than directly
modifying the pointer value itself.


david
