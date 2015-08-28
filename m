Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30412 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbH1CRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 22:17:07 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t7S2H6QG011779
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 02:17:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t7S2H6rY019814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 02:17:06 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t7S2H6CX029305
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 02:17:06 GMT
Subject: Re: [PATCH 0/3] introduce function to handle device offline
To: linux-btrfs@vger.kernel.org
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <55DFC497.9010107@oracle.com>
Date: Fri, 28 Aug 2015 10:16:55 +0800
MIME-Version: 1.0
In-Reply-To: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


   Just a reminder. Any comments ?

Thanks Anand


On 04/08/2015 22:43, Anand Jain wrote:
> Here the patch 3/3 below adds a function to handle device offline,
> also in this patch the device offline is triggred by the external
> sysfs interface.
> Patch 1/3 makes it possible to mount a or continue to be rw mounted
> (if -o degraded option is set or if tolerated failure is more than
> missing) when one of the device goes offline in midest of the mounted
> FS.
> Patch 2/3 fixes a bug.
>
> Anand Jain (3):
>    Btrfs: allow -o rw,degraded for single group profile
>    Btrfs: fix null pointer dereference when extent buffer is already
>      freed
>    Btrfs: introduce function to handle device offline
>
>   fs/btrfs/disk-io.c |   6 ++-
>   fs/btrfs/super.c   |   3 +-
>   fs/btrfs/sysfs.c   |  20 +++++++++-
>   fs/btrfs/volumes.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/volumes.h |   7 ++++
>   5 files changed, 145 insertions(+), 4 deletions(-)
>
