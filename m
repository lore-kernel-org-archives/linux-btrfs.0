Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:38683 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbcGEGzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jul 2016 02:55:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id DF16B35A275
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 08:55:06 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Ubggnvb0_iW for <linux-btrfs@vger.kernel.org>;
	Tue,  5 Jul 2016 08:55:06 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 08:55:06 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Jul 2016 15:55:06 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem read only after power outage
In-Reply-To: <7db11e52ffdd949a917036bc38f4b0f1@admin.virtall.com>
References: <7db11e52ffdd949a917036bc38f4b0f1@admin.virtall.com>
Message-ID: <f98c7bca36bd8d075fcde4aff0c1fbed@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-05 14:56, Tomasz Chmielewski wrote:
> Getting this lengthy output logged, and the fs mounter read-only after
> a power outage.
> 
> 
> Tried also 4.6.3, but it ends just alike.
> 
> Jul  5 02:04:20 bkp011 kernel: [  799.298303] ------------[ cut here
> ]------------
> Jul  5 02:04:20 bkp011 kernel: [  799.298335] WARNING: CPU: 0 PID:
> 1896 at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:6599
> __btrfs_free_extent.isra.70+0x877/0xd50 [btrfs]


FYI, 4.7-rc6 breaks just like 4.6.0 and 4.6.3.


Tomasz Chmielewski
https://wpkg.org
