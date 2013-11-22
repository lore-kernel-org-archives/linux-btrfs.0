Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3KVIrl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 03:47:41 -0500
Date: Fri, 22 Nov 2013 16:47:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: wake up the tasks that wait for the io earlier
Message-ID: <20131122084727.GA30739@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
 <20131122043039.GE25977@localhost.localdomain>
 <528F07A0.9040602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <528F07A0.9040602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 03:28:32PM +0800, Miao Xie wrote:
> On Fri, 22 Nov 2013 12:30:40 +0800, Liu Bo wrote:
> > On Thu, Nov 21, 2013 at 09:43:14PM +0800, Miao Xie wrote:
> >> The tasks that wait for the IO_DONE flag just care about the io of the dirty
> >> pages, so it is better to wake up them immediately after all the pages are
> >> written, not the whole process of the io completes.
> > 
> > This doesn't seem to make sense, the waiters still go to wait and schedule since
> > IO_DONE is not set there yet.
> 
> I can not understand what you said. We wake up the waiters after IO_DONE is set,
> the waiters who wait for IO_DONE flag will not go to wait.
> 
> Miao
> 
> > 
> > -liubo
> > 
> >>
> >> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/ordered-data.c | 14 ++++++++++----
> >>  1 file changed, 10 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> >> index eb5bac4..1bd7002 100644
> >> --- a/fs/btrfs/ordered-data.c
> >> +++ b/fs/btrfs/ordered-data.c
> >> @@ -348,10 +348,13 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
> >>  	if (!uptodate)
> >>  		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
> >>  
> >> -	if (entry->bytes_left == 0)
> >> +	if (entry->bytes_left == 0) {
> >>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> >> -	else

My bad, something got in my eye, I was thinking 'else' is keeped.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
-liubo

> >> +		if (waitqueue_active(&entry->wait))
> >> +			wake_up(&entry->wait);
> >> +	} else {
> >>  		ret = 1;
> >> +	}
> >>  out:
> >>  	if (!ret && cached && entry) {
> >>  		*cached = entry;
> >> @@ -408,10 +411,13 @@ have_entry:
> >>  	if (!uptodate)
> >>  		set_bit(BTRFS_ORDERED_IOERR, &entry->flags);
> >>  
> >> -	if (entry->bytes_left == 0)
> >> +	if (entry->bytes_left == 0) {
> >>  		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
> >> -	else
> >> +		if (waitqueue_active(&entry->wait))
> >> +			wake_up(&entry->wait);
> >> +	} else {
> >>  		ret = 1;
> >> +	}
> >>  out:
> >>  	if (!ret && cached && entry) {
> >>  		*cached = entry;
> >> -- 
> >> 1.8.3.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
