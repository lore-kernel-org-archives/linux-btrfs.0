Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48315 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbcKZNqg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 08:46:36 -0500
Date: Sat, 26 Nov 2016 08:46:38 -0500
From: Chris Mason <clm@fb.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: still lockdep splat for 4.9-rc5+ (btrfs_log_inode)
Message-ID: <20161126134638.GA79987@clm-mbp.masoncoding.com>
References: <b9063be2-8c01-2c15-ca2d-8460594128cf@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <b9063be2-8c01-2c15-ca2d-8460594128cf@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 10:03:25AM +0100, Christian Borntraeger wrote:
>FWIW, I still see the lockdep splat in btrfs in 4.9-rc5+

Filipe reworked the code to avoid taking the same lock twice.  As far as 
I can tell, this just needs some annotation.

-chris
