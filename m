Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3DZJhJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 05:37:09 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3Q9b7re027795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:37:08 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9b7U8002551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:37:07 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3Q9b7j9002546
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 09:37:07 GMT
Message-ID: <517A4B44.5060608@oracle.com>
Date: Fri, 26 Apr 2013 17:39:16 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: device delete to get errors from the kernel
References: <51623C0C.4060709@oracle.com>
In-Reply-To: <51623C0C.4060709@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  As showed in the previous email in this thread, we need to get
  the error string from the kernel to the cli to improve the
  usability of the product.
  As also said, I was looking at two way which I think we could
  do this, here I take the 2nd approach which is to pass the error
  string though the ioctl args. Which leads to change in the
  ioctl-structure. But..

  This comes with a caveat that both btrfs-progs and btrfs-kernel
  patch together either must be applied or removed.

   [PATCH] btrfs-progs: device delete to get errors from the kernel
   [PATCH] btrfs: device delete to get errors from the kernel

  Which is not a developer/integrator friendly rule. If there
  is anything I could do to help on this pls do let me know.

  There are quite a number of cli which needs passing of the
  the error string from the kernel to cli. Which I plan to work
  once we finalize the approach to address this issue.

  Thanks for your time to review this.

Anand
