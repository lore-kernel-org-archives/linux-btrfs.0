Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:56784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbbLILBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 06:01:38 -0500
From: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: freeze_bdev and scrub/re-balance
Date: Wed, 9 Dec 2015 11:01:35 +0000
Message-ID: <CY1PR10MB04287C587E5F87A56289F282E4E80@CY1PR10MB0428.namprd10.prod.outlook.com>
References: <CY1PR10MB0428B98E759584F476DB4CF3E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
 <CY1PR10MB0428E36B7C37C92740306A60E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
In-Reply-To: <CY1PR10MB0428E36B7C37C92740306A60E40B0@CY1PR10MB0428.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can anyone help me with this question?

Not only the kernel space API freeze_bdev, but also the IO control which can be called from user space.



-----Original Message-----
From: Wang, Zhiye 
Sent: Saturday, December 5, 2015 5:57 PM
To: linux-btrfs@vger.kernel.org
Subject: freeze_bdev and scrub/re-balance

Hi all,


If I understand it correctly, defragment operation is done in user space tools, while scrub/re-balance is done in kernel thread.


So, if my kernel module calls freeze_bdev when scrub/re-balance is in progress, will I still be able to get a consistent file system state?




Thanks
Mike


     
