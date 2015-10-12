Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:61764
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750806AbbJLEh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 00:37:58 -0400
From: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Questions about FIEMAP
Date: Mon, 12 Oct 2015 04:37:55 +0000
Message-ID: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

After googled a bit, I got information that btrfs supports FIEMAP (as "cp" needs it), but it's not valid for "write" operation.

I guess we cannot write to block device directly after get block list using FIEMAP. This is because:

1. COW feature of btrfs (but this can be disabled using NOCOW)
2. File system rebalance
3. Defragmentation

Aren't item #2 and #3 also a problem for "read" operation? For example, after "cp" get block list using FIEMAP, file system rebalance occurs, So, previous result of FIEMAP is not valid anymore.

Or maybe I misunderstood something. Please correct me.



Thanks
Mike
