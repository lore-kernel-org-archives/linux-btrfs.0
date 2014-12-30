Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203AbaL3BZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 20:25:48 -0500
Message-ID: <1419902599.6318.1.camel@localhost.localdomain>
Subject: Re: [PATCH v2] btrfs-progs: Documentation: add T/P/E description
 for resize cmd
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <takeuchi_satoru@jp.fujitsu.com>
Date: Tue, 30 Dec 2014 09:23:19 +0800
In-Reply-To: <20141229160712.GK6490@twin.jikos.cz>
References: <54978DFE.6010507@jp.fujitsu.com>
	 <1419232973-4623-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20141229160712.GK6490@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-12-29 at 17:07 +0100, David Sterba wrote:
> On Mon, Dec 22, 2014 at 03:22:53PM +0800, Gui Hecheng wrote:
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> > ---
> > changelog
> > 	v1->v2: s/\'E\'(EiB)/or \'E\'(EiB)/ as suggested by Satoru, thanks.
> > ---
> >  Documentation/btrfs-filesystem.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> > index a8f2972..138ba6c 100644
> > --- a/Documentation/btrfs-filesystem.txt
> > +++ b/Documentation/btrfs-filesystem.txt
> > @@ -102,8 +102,8 @@ If the prefix + or - is present the size is increased or decreased
> >  by the quantity <size>.
> >  If no units are specified, the unit of the <size> parameter defaults to
> >  bytes. Optionally, the size parameter may be suffixed by one of the following
> > -units designators: \'K\', \'M', or \'G', kilobytes, megabytes, or gigabytes,
> > -respectively.
> > +units designators: \'K\'(KiB), \'M\'(MiB), \'G\'(GiB), \'T\'(TiB), \'P\'(PiB)
> > +or \'E\'(EiB).
> 
> I find this a bit confusing as this would suggest that eg.
> 
>   $ btrfs fi resize -1GiB
> 
> is valid.

Oh, you're right, thanks for pointing it out, then I'll just follow the
old way and send a new one.

-Gui

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


