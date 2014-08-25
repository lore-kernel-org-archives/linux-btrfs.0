Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31895 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328AbaHYO6S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 10:58:18 -0400
Message-ID: <53FB4F05.6050801@fb.com>
Date: Mon, 25 Aug 2014 10:58:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com> <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/2014 11:36 AM, Liu Bo wrote:
> This has been reported and discussed for a long time, and this hang occurs in
> both 3.15 and 3.16.

[ great description ]

I ran this through tests last week, and an overnight test over the
weekend.  It's in my for-linus branch now, along with everything else I
plan on sending for rc3.

Please double check my merge, I had to undo your rebase onto Miao's patches.

-chris
