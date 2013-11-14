Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3KNOOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 09:14:16 -0500
Date: Thu, 14 Nov 2013 15:14:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: extend -O syntax to disable features
Message-ID: <20131114141414.GJ18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384435845-8493-1-git-send-email-dsterba@suse.cz>
 <20131114135613.3802.45079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131114135613.3802.45079@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 08:56:13AM -0500, Chris Mason wrote:
> Quoting David Sterba (2013-11-14 08:30:45)
> > A way of disabling features that are on by default in case it's not
> > wanted, eg. due to lack of support in the used kernel.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> >  mkfs.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mkfs.c b/mkfs.c
> > index cd0af9ef8b4f..f825e1b6bc2d 100644
> > --- a/mkfs.c
> > +++ b/mkfs.c
> > @@ -1168,7 +1168,11 @@ static int parse_one_fs_feature(const char *name, u64 *flags)
> >         int found = 0;
> >  
> >         for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
> > -               if (!strcmp(mkfs_features[i].name, name)) {
> > +               if (name[0] == '^' &&
> > +                       !strcmp(mkfs_features[i].name, name + 1)) {
> > +                       *flags &= ~ mkfs_features[i].flag;
> > +                       found = 1;
> > +               } else if (!strcmp(mkfs_features[i].name, name)) {
> >                         *flags |= mkfs_features[i].flag;
> >                         found = 1;
> >                 }
> 
> Perfect, I was going to do this today so I can enable extrefs.

Just sent :)
