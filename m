Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44604 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbaFRBwO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 21:52:14 -0400
Message-ID: <53A0F0C6.9070606@oracle.com>
Date: Wed, 18 Jun 2014 09:52:06 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: clm@fb.com, Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/24] btrfs: return actual error on btrfs_init_sysfs
References: <53A0516D.5040607@oracle.com>
In-Reply-To: <53A0516D.5040607@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 06/17/2014 22:32 PM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if call kset_create_and_add() failed
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Please ignore this patch because Greg think that is incorrect.


Cheers,
-Jeff
