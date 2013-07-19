Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41527 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3GSJ0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 05:26:49 -0400
Message-ID: <51E90785.9070402@oracle.com>
Date: Fri, 19 Jul 2013 17:31:49 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix get set label blocking against balance
References: <51E655D1.5020309@oracle.com> <1374146298-30789-1-git-send-email-anand.jain@oracle.com> <51E7E3E3.9000008@giantdisaster.de>
In-Reply-To: <51E7E3E3.9000008@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Instead the spinlock super_lock looks appropriate for
> protecting concurrent access to the label field of fs_info->super_copy.
> In btrfs_ioctl_set_fslabel() make sure to only hold the spinlock for the
> copy operation, not while calling the transaction functions.

  Oh yeah ! fs_info->super_lock is most suitable.
  its right there. Thanks.

  New patch has been sent out.

Thanks.
Anand
