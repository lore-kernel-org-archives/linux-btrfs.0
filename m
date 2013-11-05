Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60356 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3KENxf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 08:53:35 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 771129A06D0
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Nov 2013 06:53:35 -0700 (MST)
Date: Tue, 5 Nov 2013 08:53:33 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Kent Overstreet <kmo@daterainc.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <axboe@kernel.dk>, <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <chris.mason@fusionio.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 1/9] block: Convert various code to bio_for_each_segment()
Message-ID: <20131105135333.GB27784@localhost.localdomain>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-2-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383608187-27368-2-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 03:36:19PM -0800, Kent Overstreet wrote:
> With immutable biovecs we don't want code accessing bi_io_vec directly -
> the uses this patch changes weren't incorrect since they all own the
> bio, but it makes the code harder to audit for no good reason - also,
> this will help with multipage bvecs later.
> 

The btrfs parts of this look good to me, you can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks for this,

Josef
