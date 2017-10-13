Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:48448 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753329AbdJMNSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:18:32 -0400
Received: by mail-qk0-f193.google.com with SMTP id d67so4943049qkg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 06:18:32 -0700 (PDT)
Date: Fri, 13 Oct 2017 09:18:30 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/21] btrfs: make the delalloc block rsv per inode
Message-ID: <20171013131829.3crywvezqhhhyauc@destiny>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-4-git-send-email-jbacik@fb.com>
 <71428c63-d89d-34dc-bf53-9a010ae4de1a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <71428c63-d89d-34dc-bf53-9a010ae4de1a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 02:47:32PM +0300, Nikolay Borisov wrote:
> 
> 
> > @@ -8848,7 +8849,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> >  	if (iov_iter_rw(iter) == WRITE) {
> >  		up_read(&BTRFS_I(inode)->dio_sem);
> >  		current->journal_info = NULL;
> > -		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
> >  		if (ret < 0 && ret != -EIOCBQUEUED) {
> >  			if (dio_data.reserve)
> >  				btrfs_delalloc_release_space(inode, data_reserved,
> > @@ -8869,6 +8869,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> >  		} else if (ret >= 0 && (size_t)ret < count)
> >  			btrfs_delalloc_release_space(inode, data_reserved,
> >  					offset, count - (size_t)ret);
> 
> In case we didn't manage to write everything we are releasing the extra
> stuff that wasn't written.
> 
> > +		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
> In case btrfs_delalloc_release_space triggered wouldn't freeing metadata
> here cause some sort of an underflow? Shouldn't we adjust count in case
> we have already freed anything beforehand?
> 

No, btrfs_delalloc_release_extents() is only for modifying the
outstanding_extents and adjusting the reservation,
btrfs_delalloc_release_space() takes care of the outstanding csum_bytes and
adjusts the reservation.  Thanks,

Josef
