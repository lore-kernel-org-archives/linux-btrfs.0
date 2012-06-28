Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51784 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2F1JnN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jun 2012 05:43:13 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5S9hCU4000415
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 09:43:13 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q5S9hB8Q009909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 09:43:12 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q5S9hBA0031126
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 04:43:11 -0500
Message-ID: <4FEC2662.6070404@oracle.com>
Date: Thu, 28 Jun 2012 17:39:46 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs-debug-tree -e
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi,

  Looks like commit fcdc0929c6ea051dad59818210df53fd03eaf4b1
  removed the function print_extent_leaf

---
  static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
  {
         int i;
@@ -81,10 +43,7 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)

         if (!eb)
                 return;
-       if (btrfs_is_leaf(eb)) {
-               print_extent_leaf(root, eb);
-               return;
-       }
+
---

  which made 'btrfs-debug-tree -e' stop working.
  any comments on why it was done ?

thanks Anand



