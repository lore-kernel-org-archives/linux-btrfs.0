Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30937 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3GOExF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 00:53:05 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6F4r28p018974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:03 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F4r2qX029790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:02 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F4r15p027416
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 04:53:01 GMT
Message-ID: <51E3815C.7030608@oracle.com>
Date: Mon, 15 Jul 2013 12:58:04 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 13/13] btrfs-progs: fix memory leaks of device_list_add()
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com> <1373269140-29733-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373269140-29733-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  A complete fix for the memory leak caused by device_list_add()
  is more complicated than initial idea and so sorry that I
  have to pull back this patch as well.


  The main reason-
     There are uncoordinated scan for btrfs which would result
     in doing the same thing multiple times.

     For a eg: consider the following..
-----------
int cmd_check(int argc, char **argv)
{
::
         if((ret = check_mounted(argv[optind])) < 0) {
::
         info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1);
-----------

     Both of these functions (check_mounted() and open_ctree_fs_info())
     would perform a complete scan of /dev separately. This is
     one of the situation and there are quite a number of threads in
     btrfs-progs which would scan the /dev multiple times.
     this affects performance and will be noticeable
     in data centers with large number of disks/luns.


  I have to dig to develop a comprehensive fix, basically we need
  to revamp and develop a centralized device identification
  and management for the btrfs-progs which will also fix the
  apparent memory leak issues.

  Any feedback comments are welcome.

Thanks, Anand



 > further, mkfs.c thread should call device_list_remove()
 > as well, however mkfs.c uses a lot of in-flight exits()
 > which makes it very difficult to bring in this fix into
 > mkfs.c.  I shall be doing it in a separate patch.

