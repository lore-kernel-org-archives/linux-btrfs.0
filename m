Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33058 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751484AbcGKUjn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 16:39:43 -0400
Subject: Re: [PATCH v2] Btrfs: fix unexpected balance crash due to BUG_ON
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <64dda7b5-57b8-0d9c-55ce-0b13ea811f80@fb.com>
Date: Mon, 11 Jul 2016 16:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>



On 07/11/2016 01:21 PM, Liu Bo wrote:
> Mounting a btrfs can resume previous balance operations asynchronously.
> An user got a crash when one drive has some corrupt sectors.
>
> Since balance can cancel itself in case of any error, we can gracefully
> return errors to upper layers and let balance do the cancel job.
>
> Reported-by: sash <master.b.at.raven@chefmail.de>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

v2 Looks good, thanks Liu.

Signed-off-by: Chris Mason <clm@fb.com>
