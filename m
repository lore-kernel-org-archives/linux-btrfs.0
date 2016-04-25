Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbcDYMtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:49:17 -0400
Date: Mon, 25 Apr 2016 14:49:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] btrfs: send: silence an integer overflow warning
Message-ID: <20160425124905.GJ23222@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160413064059.GB8092@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160413064059.GB8092@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 13, 2016 at 09:40:59AM +0300, Dan Carpenter wrote:
> The "sizeof(*arg->clone_sources) * arg->clone_sources_count" expression
> can overflow.  It causes several static checker warnings.  It's all
> under CAP_SYS_ADMIN so it's not that serious but lets silence the
> warnings.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
