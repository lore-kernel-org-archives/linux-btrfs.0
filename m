Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35079 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbbDITDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:03:55 -0400
Received: by pabtp1 with SMTP id tp1so52909929pab.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:03:54 -0700 (PDT)
Date: Thu, 9 Apr 2015 12:03:52 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: unify subvol= and subvolid= mounting
Message-ID: <20150409190352.GA12447@mew>
References: <cover.1428471096.git.osandov@osandov.com>
 <0d43234f1b2c1d35a06e8259ca94c7d976e0a604.1428471096.git.osandov@osandov.com>
 <20150409162848.GH25622@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150409162848.GH25622@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 06:28:48PM +0200, David Sterba wrote:
> On Tue, Apr 07, 2015 at 10:34:01PM -0700, Omar Sandoval wrote:
> > Currently, mounting a subvolume with subvolid= takes a different code
> > path than mounting with subvol=. This isn't really a big deal except for
> > the fact that mounts done with subvolid= or the default subvolume don't
> > have a dentry that's connected to the dentry tree like in the subvol=
> > case. To unify the code paths, when given subvolid= or using the default
> > subvolume ID, translate it into a subvolume name by walking
> > ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.
> 
> Can you please split this patches? It's doing several things, but the
> core change will probably be a big one. The mount path is not trivial,
> all the recursions and argument replacements.

Will do.

> Otherwise, I'm ok with this approach, ie. to set up the dentry at mount
> time.
> 
> A few comments below.
> 
> >  /*
> > - * This will strip out the subvol=%s argument for an argument string and add
> > - * subvolid=0 to make sure we get the actual tree root for path walking to the
> > - * subvol we want.
> > + * This will add subvolid=0 to the argument string while removing any subvol=
> > + * and subvolid= arguments to make sure we get the top-level root for path
> > + * walking to the subvol we want.
> >   */
> >  static char *setup_root_args(char *args)
> >  {
> > -	unsigned len = strlen(args) + 2 + 1;
> > -	char *src, *dst, *buf;
> > -
> > -	/*
> > -	 * We need the same args as before, but with this substitution:
> > -	 * s!subvol=[^,]+!subvolid=0!
> > -	 *
> > -	 * Since the replacement string is up to 2 bytes longer than the
> > -	 * original, allocate strlen(args) + 2 + 1 bytes.
> > -	 */
> > +	char *p, *dst, *buf;
> 
> Fix the coding style.

Ok.

> >  	root = mount_subtree(mnt, subvol_name);
> > +	mnt = NULL; /* mount_subtree drops our reference on the vfsmount. */
> 
> Put the comment on a separate line.

Ok.

> > +	if (!IS_ERR(root) && subvol_objectid &&
> > +	    BTRFS_I(root->d_inode)->root->root_key.objectid != subvol_objectid) {
> > +		pr_warn("BTRFS: subvol '%s' does not match subvolid %llu\n",
> > +			subvol_name, subvol_objectid);
> 
> We should define the precedence of subvolid and subvol if both are set.
> A warning might not be enough.

Ah, that probably deserves some more explanation. My original intent was
to alert the user if there was a race where the subvolume passed by ID
was renamed and another subvolume was renamed over the old location.
Then I figured that users should probably be warned if they are passing
bogus mount options, too.

However, I just now realized that the current behavior will error out in
that case anyways because before this patch, setup_root_args() only
replaces the first subvol= and ignores anything that comes after it. So
subvol=/foovol,subvolid=258 becomes subvolid=0,subvolid=258 and the last
one takes precedence, so the lookup of /foovol happens inside of subvol
258 instead of the top-level and fails.

So I think reasonable behavior would be to change that warning into a
hard error for both cases (the race and the misguided user). Just in
case a user copies the mount options straight out of /proc/mounts or
something, we can allow both subvol= and subvolid= to be passed, but
only if they match.

Thanks for the review!
-- 
Omar
