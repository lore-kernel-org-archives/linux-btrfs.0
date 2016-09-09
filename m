Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752630AbcIIPhl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 11:37:41 -0400
Date: Fri, 9 Sep 2016 17:36:02 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: check: remove unused found_key variable
 in walk_down_tree()
Message-ID: <20160909153602.GX16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
 <20160829162217.GW16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160829162217.GW16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 29, 2016 at 06:22:17PM +0200, David Sterba wrote:
> On Thu, Aug 25, 2016 at 01:20:59PM +0800, Wang Xiaoguang wrote:
> > Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> > ---
> >  cmds-check.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/cmds-check.c b/cmds-check.c
> > index 0ddfd24..1cd0421 100644
> > --- a/cmds-check.c
> > +++ b/cmds-check.c
> > @@ -3737,7 +3737,6 @@ static int check_fs_root(struct btrfs_root *root,
> >  		path.slots[level] = 0;
> >  	} else {
> >  		struct btrfs_key key;
> > -		struct btrfs_disk_key found_key;
> >  
> >  		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
> >  		level = root_item->drop_level;
> > @@ -3745,10 +3744,6 @@ static int check_fs_root(struct btrfs_root *root,
> >  		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> >  		if (wret < 0)
> >  			goto skip_walking;
> > -		btrfs_node_key(path.nodes[level], &found_key,
> > -				path.slots[level]);
> > -		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
> > -					sizeof(found_key)));
> 
> It's not unused, the WARN_ON is an if in disguise, ane memcmp does the
> check, am I missing something here?

So, the warning should stay, please replace it with an if and a message,
unless there are other reasons to drop the check completely.
