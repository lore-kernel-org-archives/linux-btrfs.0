Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22089 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbDNJ3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 05:29:20 -0400
Date: Tue, 14 Apr 2015 17:29:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: make "BTRFS_UTIL_PROG filesystem defragment"
 work
Message-ID: <20150414092902.GA1784@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1429002060-16597-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H4kacnDiQLpBr0ZMKCPY7dK=uO-PPrNmhUqiWutMY5k=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4kacnDiQLpBr0ZMKCPY7dK=uO-PPrNmhUqiWutMY5k=g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 14, 2015 at 10:14:59AM +0100, Filipe David Manana wrote:
> On Tue, Apr 14, 2015 at 10:01 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > _require_defrag() needs to check if the command is executable, but btrfs has
> > its subcommand "filesystem defragment", which makes this checking fail.
> >
> > This workarounds it and now we can run case generic/324, generic/018, btrfs/005.
> 
> There's already a patch from Zhao to fix the regression:
> 
> https://patchwork.kernel.org/patch/6205031/

Got it, thanks for pointing it out.

Thanks,

-liubo

> 
> thanks
> 
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  common/defrag | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/common/defrag b/common/defrag
> > index f923dc0..f36a68b 100644
> > --- a/common/defrag
> > +++ b/common/defrag
> > @@ -37,7 +37,11 @@ _require_defrag()
> >         ;;
> >      esac
> >
> > -    _require_command "$DEFRAG_PROG" defragment
> > +    if [ "$FSTYP" == "btrfs" ]; then
> > +           _require_command "$BTRFS_UTIL_PROG" defragment
> > +    else
> > +           _require_command "$DEFRAG_PROG" defragment
> > +    fi
> >      _require_xfs_io_command "fiemap"
> >  }
> >
> > --
> > 1.8.2.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
