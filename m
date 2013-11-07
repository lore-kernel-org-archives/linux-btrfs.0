Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57183 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3KGRY2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 12:24:28 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 03B179A0364
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Nov 2013 10:24:28 -0700 (MST)
Date: Thu, 7 Nov 2013 12:24:25 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 01/17] btrfs: Cleanup the unused struct async_sched.
Message-ID: <20131107172425.GH27784@localhost.localdomain>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1383803527-23736-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383803527-23736-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 01:51:51PM +0800, Qu Wenruo wrote:
> The struct async_sched is not used by any codes and can be removed.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
