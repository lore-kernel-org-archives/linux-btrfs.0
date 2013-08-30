Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41223 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3MY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 08:24:29 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A271A9A06A0
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 06:24:28 -0600 (MDT)
Date: Fri, 30 Aug 2013 08:24:24 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix send to deal with sparse files properly V2
Message-ID: <20130830122424.GG10591@localhost.localdomain>
References: <1377186470-4000-1-git-send-email-jbacik@fusionio.com>
 <5220003F.6090103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5220003F.6090103@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 10:15:27AM +0800, Wang Shilong wrote:
> On 08/22/2013 11:47 PM, Josef Bacik wrote:
> 
> please use checkpatch.pl to check coding styles before sending patches:
> 
> WARNING: line over 80 characters
> #86: FILE: fs/btrfs/send.c:4051:
> +            if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0) {
> 
> total: 0 errors, 1 warnings, 59 lines checked
>

Yeah I did that on purpose, thanks,

Josef 
