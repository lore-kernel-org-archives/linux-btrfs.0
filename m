Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49732 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbbHTDT7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 23:19:59 -0400
Message-ID: <55D546C5.7000202@oracle.com>
Date: Thu, 20 Aug 2015 11:17:25 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel 4.1.4 btrfs forced read-only during rsync
References: <CAJtFHUQukRC9m+Bq85CN7v_tCk6ybGvParax5ixcMJwKHRUFCQ@mail.gmail.com>
In-Reply-To: <CAJtFHUQukRC9m+Bq85CN7v_tCk6ybGvParax5ixcMJwKHRUFCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


two to dig more..

> Aug 16 04:41:31 [1082957.226817] BTRFS: error (device sdb) in
> __btrfs_free_extent:6235: errno=-28 No space left
> Aug 16 04:41:31 [1082957.226819] BTRFS info (device sdb): forced readonly

::

> Aug 16 04:41:31 [1082957.289289] BTRFS: error (device sdb) in
> cleanup_transaction:1692: errno=-5 IO failure

1.
  We probably need to understand what kicked in readonly. is it
  -28 (No space left) OR -5 (EIO).

2.
  There are no media errors from the block layer, hope we are not
  fabricating the EIO in the FS layer... thats wrong.

digging more.

Thanks,  Anand
