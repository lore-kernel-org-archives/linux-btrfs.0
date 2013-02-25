Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57917 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3BYR1W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 12:27:22 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 88F727C0401
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 10:27:21 -0700 (MST)
Date: Mon, 25 Feb 2013 12:27:19 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Aastha Mehta <aasthakm@gmail.com>
CC: Josef Bacik <josef@toxicpanda.com>, Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding COW in Btrfs
Message-ID: <20130225172719.GA2434@localhost.localdomain>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain>
 <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
 <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
 <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 08:15:40AM -0700, Aastha Mehta wrote:
> Thanks again Josef.
> 
> I understood that cow_file_range is called for a regular file. Just to
> clarify, in cow_file_range is cow done at the time of reserving
> extents in the extent btree for the io to be done in this delalloc? I
> see the following comment above find_free_extent() which is called
> while trying to reserve extents:
> 
> /*
>  * walks the btree of allocated extents and find a hole of a given size.
>  * The key ins is changed to record the hole:
>  * ins->objectid == block start
>  * ins->flags = BTRFS_EXTENT_ITEM_KEY
>  * ins->offset == number of blocks
>  * Any available blocks before search_start are skipped.
>  */
> 
> This seems to be the only place where a cow might be done, because a
> key is being inserted into an extent which modifies it.
>

The key isn't inserted at this time, it's just returned with those values for us
to do as we please.  There is no update of the btree until
insert_reserved_extent/btrfs_mark_extent_written in btrfs_finish_ordered_io.
Thanks,

Josef 
