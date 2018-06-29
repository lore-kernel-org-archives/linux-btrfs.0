Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752804AbeF2Lqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 07:46:31 -0400
Date: Fri, 29 Jun 2018 13:46:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Revert "btrfs: fix a possible umount deadlock"
Message-ID: <20180629114629.GO2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530249965-24746-1-git-send-email-nborisov@suse.com>
 <1b4173b5-857c-f261-7e69-656d47aa0bcb@oracle.com>
 <de9adc8b-3131-c310-e17e-247ec375475b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <de9adc8b-3131-c310-e17e-247ec375475b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 10:13:44AM +0300, Nikolay Borisov wrote:
> On 29.06.2018 10:11, Anand Jain wrote:
> > 
> > On 06/29/2018 01:26 PM, Nikolay Borisov wrote:
> >> Since commit 88c14590cdd6 ("btrfs: use RCU in btrfs_show_devname for
> >> device list traversal") btrfs_show_devname no longer takes
> >> device_list_mutex. As such the deadlock that 0ccd05285e7f ("btrfs: fix
> >> a possible umount deadlock") aimed to fix no longer exists. So remove
> >> the extra code that commit added.
> >>
> >> This reverts commit 0ccd05285e7f5a8e297e1d6dfc41e7c65757d6fa.
> > 
> >  Its not exactly a revert.
> > 
> >  Because before 88c14590cdd6 was written, 0ccd05285e7f was already their
> >  for the right purpose OR a new title is even better.
> 
> What I'm saying is that commit 88c14590cdd6 obsoleted 0ccd05285e7f,
> hence this patch reverts the latter. I've literally generated it with
> git revert 0ccd05285e7f + minor fixups.

I do not recommend to do a revert here.  Even if a patch reverts
functionality because it's not needed anymore, then it's a "forward"
change.  There are also other changes that may affect the behaviour and
in this case it's 47dba17171a76ea2a2a71 that removes rcu barrier, so the
patch has to be put into the context of current code.

The commit is almost 2 years old, the idea of reverts is IMHO more to
provide an easy way do a small step back during one devlopment cycle
when the moving parts are still in sight.

Back then the commit fixed a deadlock, a revert here would read as 'ok,
we want the deadlock back'.

So, the code is ok. The subject needs to drop the word 'revert' and
changelg maybe mention a few more references why the logic is not needed
anymore.
