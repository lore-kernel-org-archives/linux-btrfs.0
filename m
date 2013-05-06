Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54965 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3EFTjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 15:39:12 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F38679A0414
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 13:39:11 -0600 (MDT)
Date: Mon, 6 May 2013 15:39:09 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: device delete to get errors from the kernel
Message-ID: <20130506193909.GK12414@localhost.localdomain>
References: <517FC485.3080208@oracle.com>
 <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1367327981-28000-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 30, 2013 at 07:19:40AM -0600, Anand Jain wrote:
> v1->v2:
> introduce error codes for the device mgmt usage
> 
> v1:
> adds a parameter in the ioctl arg struct to carry the error string
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---

I need a proper log for this patch.  Thanks,

Josef
