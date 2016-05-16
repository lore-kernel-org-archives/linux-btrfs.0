Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33976 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbcEPMev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:34:51 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>, "'Scott Talbert'" <scott.talbert@hgst.com>
CC: <linux-btrfs@vger.kernel.org>
References: <1462799668-26910-1-git-send-email-scott.talbert@hgst.com> <20160509173220.GO29353@twin.jikos.cz> 
In-Reply-To: 
Subject: RE: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
Date: Mon, 16 May 2016 20:34:37 +0800
Message-ID: <005601d1af6f$4f6450a0$ee2cf1e0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Scott Talbert

> From: Zhao Lei [mailto:zhaolei@cn.fujitsu.com]
> Sent: Friday, May 13, 2016 6:31 PM
> To: 'dsterba@suse.cz' <dsterba@suse.cz>; 'Scott Talbert'
> <scott.talbert@hgst.com>
> Cc: 'linux-btrfs@vger.kernel.org' <linux-btrfs@vger.kernel.org>
> Subject: RE: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
> 
> Hi, Scott Talbert
> 
> * From: David Sterba [mailto:dsterba@suse.cz]
> > Sent: Tuesday, May 10, 2016 1:32 AM
> > To: Scott Talbert <scott.talbert@hgst.com>
> > Cc: linux-btrfs@vger.kernel.org; Zhao Lei <zhaolei@cn.fujitsu.com>
> > Subject: Re: [PATCH] btrfs: fix memory leak during RAID 5/6 device
> replacement
> >
> > CC Zhao Lei <zhaolei@cn.fujitsu.com>
> >
> > On Mon, May 09, 2016 at 09:14:28AM -0400, Scott Talbert wrote:
> > > A 'struct bio' is allocated in scrub_missing_raid56_pages(), but it was never
> > > freed anywhere.
> > >
> > > Signed-off-by: Scott Talbert <scott.talbert@hgst.com>
> > > ---
> > >  fs/btrfs/scrub.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > > index 82bedf9..607cc6e 100644
> > > --- a/fs/btrfs/scrub.c
> > > +++ b/fs/btrfs/scrub.c
> > > @@ -2130,6 +2130,8 @@ static void scrub_missing_raid56_end_io(struct
> > bio *bio)
> > >  	if (bio->bi_error)
> > >  		sblock->no_io_error_seen = 0;
> > >
> > > +	bio_put(bio);
> > > +
> Seems good by reviewing.
> I'll add some debug code to test it more detailedly.
> 
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Test-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Thanks
Zhaolei

> Thanks
> Zhaolei
> 
> > >  	btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
> > >  }
> > >
> > > --
> > > 1.9.1
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html




