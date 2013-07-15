Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35314 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3GOEx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 00:53:29 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6F4rSof003041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:29 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F4rRBC027940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:28 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F4rRHX021700
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:27 GMT
Message-ID: <51E38176.8030609@oracle.com>
Date: Mon, 15 Jul 2013 12:58:30 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/12] Btrfs-progs: Don't free the devices when close
 the ctree
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com> <1372857920-4678-4-git-send-email-miaox@cn.fujitsu.com> <51DA471C.20805@oracle.com>
In-Reply-To: <51DA471C.20805@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>   I am sending a patch to fix the the memory leak. So
>   its fine if this patch just address the close issue.

  This is more complicated than initially thought and it
  isn't ready. As explained in the other thread.

Thanks, Anand

