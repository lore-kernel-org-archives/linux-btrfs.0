Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaDYKhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:37:33 -0400
Date: Fri, 25 Apr 2014 18:37:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs-progs: set string end sing '\0' for property
Message-ID: <20140425103722.GB6138@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1398407399-10963-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5jR5xDWi=jKTu_HthUpjzp9hFEByueXBru0Edj=o1o6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5jR5xDWi=jKTu_HthUpjzp9hFEByueXBru0Edj=o1o6g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 11:07:49AM +0100, Filipe David Manana wrote:
> On Fri, Apr 25, 2014 at 7:29 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > Set string "xattr_name" 's end with '\0' so that it won't be
> > violated in memory.
> >
> > With this fix, xfstest/btrfs/048 can pass on my box.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  props.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/props.c b/props.c
> > index 4d0aeea..53223a3 100644
> > --- a/props.c
> > +++ b/props.c
> > @@ -135,6 +135,7 @@ static int prop_compression(enum prop_object_type type,
> >         }
> >         memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
> >         memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
> > +       xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
> 
> Buffer overrun. You need to sum + 1 to the malloc argument above.

Oops, I made that mistake.

thanks,
-liubo
