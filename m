Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbcBJKor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 05:44:47 -0500
Date: Wed, 10 Feb 2016 11:44:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [RFC PATCH V11 01/21] Btrfs: subpagesize-blocksize: Fix whole
 page read.
Message-ID: <20160210104424.GD30511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433172176-8742-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1433172176-8742-2-git-send-email-chandan@linux.vnet.ibm.com>
 <20150619044536.GA31508@localhost.localdomain>
 <2574653.62sO1fmDVj@localhost.localdomain>
 <20150623083747.GA1641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150623083747.GA1641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 04:37:48PM +0800, Liu Bo wrote:
...
> > | - clear BLK_STATE_IO    | - clear BLK_STATE_IO    |             |
> > | - page_read_complete    | - page_read_complete    |             |
> > |   - returns true        |   - returns true        |             |
> > |   - unlock_page()       |                         |             |
> > |                         |                         | lock_page() |
> > |                         |   - unlock_page()       |             |
> > |-------------------------+-------------------------+-------------|
> > 
> > So we end up incorrectly unlocking the page twice and "Task C" ends up working
> > on an unlocked page. So private->io_lock makes sure that only one of the tasks
> > gets "true" as the return value when page_read_complete() is invoked. As an
> > optimization the patch gets the io_lock only when nr_sectors counter reaches
> > the value 0 (i.e. when the last block of the bio_vec is being processed).
> > Please let me know if my analysis was incorrect.
> 
> Thanks for the nice explanation, it looks reasonable to me.

Please don't hesitate to add your reviewed-by if you spent time on that
and think it's ok, this rellay helps to make decisions about merging.
