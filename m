Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:36939 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933004Ab3HNUrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 16:47:25 -0400
Message-ID: <520BED03.6040707@sgi.com>
Date: Wed, 14 Aug 2013 15:48:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: btrfs/003: regression test for subvol delete
 V3
References: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2013 03:07 PM, Josef Bacik wrote:
> We were allowing users to delete their default subvolume, which is problematic.
> This test is a regression test to make sure we don't let that happen in the
> future.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3: remove comment and abstract out the subvolid logic as per Eric's
>    suggestions
> V1->V2: address the comments made by Eric Sandeen.

Thanks for the patch Josef, this has been committed.

--Rich

commit f3df3fab7d3870aab222512126b06668d7db5d71
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Wed Aug 14 20:07:52 2013 +0000

     xfstests: btrfs/009: regression test for subvol delete

     We were allowing users to delete their default subvolume, which is 
problematic.
     This test is a regression test to make sure we don't let that 
happen in the
     future.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     [rjohnston: renumbered test from 003 to 009]

