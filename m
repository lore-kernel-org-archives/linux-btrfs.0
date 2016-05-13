Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64496 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbcEMKbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 06:31:31 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>, "'Scott Talbert'" <scott.talbert@hgst.com>
CC: <linux-btrfs@vger.kernel.org>
References: <1462799668-26910-1-git-send-email-scott.talbert@hgst.com> <20160509173220.GO29353@twin.jikos.cz>
In-Reply-To: <20160509173220.GO29353@twin.jikos.cz>
Subject: RE: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
Date: Fri, 13 May 2016 18:31:23 +0800
Message-ID: <002401d1ad02$98b3e000$ca1ba000$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Scott Talbert

* From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, May 10, 2016 1:32 AM
> To: Scott Talbert <scott.talbert@hgst.com>
> Cc: linux-btrfs@vger.kernel.org; Zhao Lei <zhaolei@cn.fujitsu.com>
> Subject: Re: [PATCH] btrfs: fix memory leak during RAID 5/6 device replacement
> 
> CC Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> On Mon, May 09, 2016 at 09:14:28AM -0400, Scott Talbert wrote:
> > A 'struct bio' is allocated in scrub_missing_raid56_pages(), but it was never
> > freed anywhere.
> >
> > Signed-off-by: Scott Talbert <scott.talbert@hgst.com>
> > ---
> >  fs/btrfs/scrub.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> > index 82bedf9..607cc6e 100644
> > --- a/fs/btrfs/scrub.c
> > +++ b/fs/btrfs/scrub.c
> > @@ -2130,6 +2130,8 @@ static void scrub_missing_raid56_end_io(struct
> bio *bio)
> >  	if (bio->bi_error)
> >  		sblock->no_io_error_seen = 0;
> >
> > +	bio_put(bio);
> > +
Seems good by reviewing.
I'll add some debug code to test it more detailedly.

Thanks
Zhaolei

> >  	btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
> >  }
> >
> > --
> > 1.9.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html




