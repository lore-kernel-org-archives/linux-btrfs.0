Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcFLFIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 01:08:38 -0400
Date: Sun, 12 Jun 2016 13:08:35 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] fstests: btrfs: test RAID5 device reappear and
 balance
Message-ID: <20160612050835.GD5140@eguan.usersys.redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1463495530-425-6-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463495530-425-6-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 17, 2016 at 10:32:10PM +0800, Anand Jain wrote:
> The test does the following:
> Initialize a RAID5 with some data
> 
> Re-mount RAID5 degraded with _dev3_ missing and write data.
> Save md5sum checkpoint1
> 
> Re-mount healthy RAID5
> 
> Let balance fix degraded blocks.
> Save md5sum checkpoint2
> 
> Re-mount RAID1 degraded now with _dev1_ missing.
> Save md5sum checkpoint3
> 
> Verify if all three md5sum matches
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

All comments for 5/6 apply here for 6/6 :)

Thanks,
Eryu
