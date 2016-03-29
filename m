Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbcC2OgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:36:23 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2TEaMCW026768
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 14:36:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u2TEaMFB000346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 14:36:22 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u2TEaLf3011220
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 14:36:22 GMT
Subject: Re: [PATCH] btrfs: debug: procfs-devlist: introduce procfs interface
 for the device list for debugging
To: linux-btrfs@vger.kernel.org
References: <1459261880-32336-1-git-send-email-anand.jain@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56FA92E5.9030801@oracle.com>
Date: Tue, 29 Mar 2016 22:36:21 +0800
MIME-Version: 1.0
In-Reply-To: <1459261880-32336-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Sorry the commit log should have been..

----
** This patch is not for integration but to debug/visualize the
btrfs device tree. **

This patch introduces profs interface /proc/fs/btrfs/devlist,
which as of now exports all the members of kernel fs_devices
including some of the patches in the ML.

usage:
    cat /proc/fs/btrfs/devlist
----
