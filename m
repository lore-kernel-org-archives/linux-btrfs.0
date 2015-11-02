Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61701 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbbKBQwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Nov 2015 11:52:46 -0500
Date: Mon, 2 Nov 2015 11:52:36 -0500
From: Chris Mason <clm@fb.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
CC: <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>, <chandan@mykolab.com>
Subject: Re: [PATCH V2] Btrfs: find_free_extent: Do not erroneously skip
 LOOP_CACHING_WAIT state
Message-ID: <20151102165236.GA9975@ret.masoncoding.com>
References: <1446318664-26750-1-git-send-email-chandan@linux.vnet.ibm.com>
 <1446452986-6581-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1446452986-6581-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 01:59:46PM +0530, Chandan Rajendra wrote:
> When executing generic/001 in a loop on a ppc64 machine (with both sectorsize
> and nodesize set to 64k), the following call trace is observed,

Thanks Chandan, I hit this same trace on x86-64 with 16K nodes.

-chris
