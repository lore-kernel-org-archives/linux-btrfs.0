Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbcCKQVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 11:21:15 -0500
Date: Fri, 11 Mar 2016 17:20:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] btrfs: scrub: silence an uninitialized variable warning
Message-ID: <20160311162052.GX18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160311080856.GB31887@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160311080856.GB31887@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 11, 2016 at 11:08:56AM +0300, Dan Carpenter wrote:
> It's basically harmless if "ref_level" isn't initialized since it's only
> used for an error message, but it causes a static checker warning.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
