Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49063 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2INFuf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 01:50:35 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E5oWYA032423
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 05:50:33 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E5oWY9016288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 05:50:32 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E5oWtb000903
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 00:50:32 -0500
Message-ID: <5052C5A0.4090803@oracle.com>
Date: Fri, 14 Sep 2012 13:50:24 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  btrfs send introduced a part of code to read kernel-data
  from user-end using pipe. We need this part of code to be
  useable outside of send sub-cmd, so that developing
  service sub-cmd can use it.
  Following this email are the patches for this purpose.

Thanks, Anand

