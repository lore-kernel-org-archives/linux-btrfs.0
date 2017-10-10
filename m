Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mpynet.fi ([82.197.21.85]:33499 "EHLO mx2.mpynet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756132AbdJJNNZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 09:13:25 -0400
Date: Tue, 10 Oct 2017 16:13:23 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: Nikolay Borisov <nborisov@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: use appropriate replacements for
 __sb_{start,end}_write calls
Message-ID: <20171010131323.GA33705@dhcp-216.srv.tuxera.com>
References: <20171010104803.GA33133@dhcp-216.srv.tuxera.com>
 <6ada5c8b-4ad0-8421-cd76-9d90df5ea24b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <6ada5c8b-4ad0-8421-cd76-9d90df5ea24b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 02:08:11PM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.10.2017 13:48, Rakesh Pandit wrote:
> > Commit a53f4f8e9c8eb ("btrfs: Don't call btrfs_start_transaction() on
> > frozen fs to avoid deadlock.") started using internal calls and we
> > replace them with more suitable ones.
> > 
> > Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
> > ---
> >  fs/btrfs/super.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 35a128a..99c21ae 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -1205,8 +1205,8 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
> >  			 * happens. The pending operations are delayed to the
> >  			 * next commit after thawing.
> >  			 */
> > -			if (__sb_start_write(sb, SB_FREEZE_WRITE, false))
> > -				__sb_end_write(sb, SB_FREEZE_WRITE);
> > +			if (sb_start_write_trylock(sb))
> > +				sb_end_write(sb)
> >  			else
> >  				return 0;
> 
> On second thought, what's to prevent the filesystem to be frozen if
> sb_start_write/sb_end_write code executes? Or even after we are in the
> middle of btrfs_start_transaction?

sb->s_writers.frozen is protected by sb->s_umount and s_umount is
held when ->sync_fs is called.

> 
> 
> >  			trans = btrfs_start_transaction(root, 0);
> > 
