Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.sophos.com ([216.47.234.212]:38389 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805Ab2FRJhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 05:37:19 -0400
Received: from mx3.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 6CFCC1883EF
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 10:29:48 +0100 (BST)
Received: from ABN-EXCH1A.green.sophos (unknown [10.100.70.61])
	by mx3.sophos.com (Postfix) with ESMTPS id 139F61883E8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 10:29:48 +0100 (BST)
From: David Pottage <David.Pottage@Sophos.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Is Btrfs stable in a big storage server?
Date: Mon, 18 Jun 2012 09:29:45 +0000
Message-ID: <E33B72079F3EBA4C91E325F2AE20429508F456@abn-exch1b.green.sophos>
References: <E33B72079F3EBA4C91E325F2AE20429508E837@abn-exch1b.green.sophos>
In-Reply-To: <E33B72079F3EBA4C91E325F2AE20429508E837@abn-exch1b.green.sophos>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am looking for the opinions on how stable btrfs is when used with a big server with lots of discs, but no fancy file system usage.

I have read the warnings about btrfs being experimental, and that I should have tested backups elsewhere.

I am working on a project to set-up a backup server that will store approximately 100 Tb of files. The average file size is around 10 Mb, but there is a lot of variability. The files are compressible on average by 50%. The anticipated workload will see files written with transparent zlib compression, occasionally read, and never modified or deleted. I don't plan to create snapshots.

I have purchased a big storage server (1) with 24 3Tb hard drives. I was considering creating a single btrfs volume spanning all the drives, with no raid, lvm or suchlike below btrfs. The server will run Ubuntu Precise, with the latest stable kernel (from kernel.org). (I don't plan to use btrfs for any system volumes)

Do you think btrfs will be stable under this workload? The data will be backed up elsewhere, but considering the massive amount of data, it will take over a month to populate the server over Gigabit Ethernet, and I don't want to do it a second time if btrfs corrupts the data.

Also, I would like to use Raid-5 on the file data, but I understand that those patches are not yet integrated. Is there an estimate of when they will be in? (realize that it would be just an estimate, but it would be nice to have an idea).

Thank you.

(1) http://www.supermicro.nl/products/system/4U/6047/SSG-6047R-E1R36N.cfm

--
David Pottage
Sophos Labs, Abingdon


________________________________

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
