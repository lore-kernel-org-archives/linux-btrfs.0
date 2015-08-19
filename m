Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3706 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbbHSGpe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 02:45:34 -0400
Date: Wed, 19 Aug 2015 16:45:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: anand jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
Message-ID: <20150819064529.GJ3902@dastard>
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-1-git-send-email-anand.jain@oracle.com>
 <1439566305-12460-2-git-send-email-anand.jain@oracle.com>
 <20150816235218.GD20596@dastard>
 <55D2B40E.5040801@oracle.com>
 <20150818221157.GE3902@dastard>
 <55D3F4FA.6080309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D3F4FA.6080309@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 11:16:10AM +0800, anand jain wrote:
> 
> 
> >Ok, SCRATCH_OPTIONS might not be the best idea here, so feel free to
> >drop it.
> 
>  I have dropped $SCRATCH_OPTIONS. (waiting to submit v8). Thanks.
> 
> >However, you've still missed the primary reason I suggested
> >_scratch_mount_options in the first place:
> 
>  I am shocked. What was missed ?

Answering the question I asked:

Q: "what do we do instead of copy'n'paste of random code fragments?"

Think on it, because the answer to that question (and it's not a
hard one) should tell you exactly what you need to do.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
