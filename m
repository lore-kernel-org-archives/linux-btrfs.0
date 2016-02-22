Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:41359 "EHLO
	18.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbcBVAQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 19:16:29 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id A502F1098097
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 01:01:09 +0100 (CET)
Date: Mon, 22 Feb 2016 01:01:07 +0100
From: Philippe Loctaux <phil@philippeloctaux.com>
To: Joe Perches <joe@perches.com>
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: ctree: added lines after variable declarations
Message-ID: <20160222000107.GA11444@carbon.home>
References: <1456098390-9859-1-git-send-email-phil@philippeloctaux.com>
 <1456098784.31061.10.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1456098784.31061.10.camel@perches.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there no need of additional blank line here particulary
or in all lines that I changed?

--
Philippe Loctaux
phil@philippeloctaux.com

On Sun, Feb 21, 2016 at 03:53:04PM -0800, Joe Perches wrote:
> On Mon, 2016-02-22 at 00:46 +0100, Philippe Loctaux wrote:
> > Added lines after variable declarations, fixing 22 checkpatch warnings.
> []
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> []
> > @@ -4592,6 +4610,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
> >  			      data_end, old_data_start + new_size - data_end);
> >  	} else {
> >  		struct btrfs_disk_key disk_key;
> > +
> >  		u64 offset;
> 
> Overzealous here.
> No additional blank line required.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
