Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:37466 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751007AbcBUBtT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 20:49:19 -0500
Message-ID: <1456019356.4031.18.camel@perches.com>
Subject: Re: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
From: Joe Perches <joe@perches.com>
To: Simon Quigley <tsimonq2@ubuntu.com>, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 20 Feb 2016 17:49:16 -0800
In-Reply-To: <56C90B73.7030702@ubuntu.com>
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
	 <1456016178-4560-1-git-send-email-tsimonq2@ubuntu.com>
	 <56C90B73.7030702@ubuntu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2016-02-20 at 18:57 -0600, Simon Quigley wrote:
> Better?

No, not really.

The alignment should be to the open parenthesis
as I wrote in the first reply.

> On 02/20/2016 06:56 PM, Simon Quigley wrote:
> > checkpatch.pl reported a warning of over 80 characters on line 1833
> > 
> > Adjusted to put &extref and &offset on a different line
> > 
> > Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
> > ---
> >   fs/btrfs/backref.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index f6dac40..956fffa 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -1830,8 +1830,8 @@ static int iterate_inode_extrefs(u64 inum,
> > struct btrfs_root *fs_root,
> >   	unsigned long ptr;
> > 
> >   	while (1) {
> > -		ret = btrfs_find_one_extref(fs_root, inum, offset,
> > path, &extref,
> > -					    &offset);
> > +		ret = btrfs_find_one_extref(fs_root, inum, offset,
> > path,
> > +							&extref,
> > &offset);
> >   		if (ret < 0)
> >   			break;
> >   		if (ret) {
> > 

