Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:54127 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752601AbcBVAHE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:07:04 -0500
Message-ID: <1456099563.31061.12.camel@perches.com>
Subject: Re: [PATCH] Btrfs: ctree: added lines after variable declarations
From: Joe Perches <joe@perches.com>
To: Philippe Loctaux <phil@philippeloctaux.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Feb 2016 16:06:03 -0800
In-Reply-To: <20160222000107.GA11444@carbon.home>
References: <1456098390-9859-1-git-send-email-phil@philippeloctaux.com>
	 <1456098784.31061.10.camel@perches.com>
	 <20160222000107.GA11444@carbon.home>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2016-02-22 at 01:01 +0100, Philippe Loctaux wrote:
> Is there no need of additional blank line here particulary
> or in all lines that I changed?

Please don't top post and just here.
> On Sun, Feb 21, 2016 at 03:53:04PM -0800, Joe Perches wrote:
> > On Mon, 2016-02-22 at 00:46 +0100, Philippe Loctaux wrote:
> > > Added lines after variable declarations, fixing 22 checkpatch warnings.
> > []
> > > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > []
> > > @@ -4592,6 +4610,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
> > >  			      data_end, old_data_start + new_size - data_end);
> > >  	} else {
> > >  		struct btrfs_disk_key disk_key;
> > > +
> > >  		u64 offset;
> > 
> > Overzealous here.
> > No additional blank line required.
