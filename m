Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63433 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab3CHDWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 22:22:21 -0500
Date: Fri, 8 Mar 2013 14:19:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Zach Brown <zab@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add a incompatible format change for smaller
 metadata extent refs
Message-ID: <20130308031942.GC23616@dastard>
References: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
 <20130307195042.GI3565@lenny.home.zabbo.net>
 <20130307212918.GB1905@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130307212918.GB1905@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 07, 2013 at 04:29:18PM -0500, Josef Bacik wrote:
> The searches do different things in different places so we have to have samey
> blobs like this until we get everybody on skinny metadata and can delete the old
> code.  Thanks,

History says that once you have a disk format out in the wild, there
will still be people using it 10 years later. IOWs, you'll probably
never be able to delete the old code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
