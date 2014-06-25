Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58496 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbaFYC1c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 22:27:32 -0400
Message-ID: <1403662935.31177.3.camel@localhost.localdomain>
Subject: Re: [PATCH 2/3] btrfs-progs: fix max mirror number error for
 chunk-recover
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 25 Jun 2014 10:22:15 +0800
In-Reply-To: <53AA313C.9010802@redhat.com>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <53AA313C.9010802@redhat.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-06-24 at 21:17 -0500, Eric Sandeen wrote:
> On 6/11/14, 9:25 PM, Gui Hecheng wrote:
> > When run chunk-recover on a health btrfs(data profile raid0, with
> > plenty of data), the program has a chance to abort on the number
> > of mirrors of an extent.
> > 
> > According to the kernel code, the max mirror number of an extent
> > is 3 not 2:
> > 	ctree.h: 		BTRFS_MAX_MIRRORS	3
> > 	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
> > just change BTRFS_NUM_MIRRORS to 3, and everything goes well.
> 
> Wouldn't it make a lot more sense, then, to change the userspace
> macro to be called BTRFS_MAX_MIRRORS as well?
> 
> -Eric
> 
Yes, Eric, unify the names between userspace and kernelspace is really a
good point. Also, I plan to move the macro into ctree.h, what do you
think?

-Gui

> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  chunk-recover.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/chunk-recover.c b/chunk-recover.c
> > index 9b46b0b..d5a688e 100644
> > --- a/chunk-recover.c
> > +++ b/chunk-recover.c
> > @@ -42,7 +42,7 @@
> >  #include "btrfsck.h"
> >  #include "commands.h"
> >  
> > -#define BTRFS_NUM_MIRRORS			2
> > +#define BTRFS_NUM_MIRRORS			3
> >  
> >  struct recover_control {
> >  	int verbose;
> > 
> 


