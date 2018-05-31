Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754239AbeEaJVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 05:21:54 -0400
Date: Thu, 31 May 2018 11:19:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: checking for NULL instead of IS_ERR
Message-ID: <20180531091909.GJ3539@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180531062111.374pq6lxrmdffun6@kili.mountain>
 <d51ba220-ca4c-c79e-51c9-1f3a21ecbde6@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d51ba220-ca4c-c79e-51c9-1f3a21ecbde6@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2018 at 03:41:41PM +0900, Misono Tomohiro wrote:
> David, could you apply this on top of my v7 patch in for-next tree?

Done.
