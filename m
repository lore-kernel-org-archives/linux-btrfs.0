Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47065 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3GQIYA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 04:24:00 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6H8NxSY023990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 08:24:00 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6H8Nwla029399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 08:23:58 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6H8Nv8w019259
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 08:23:57 GMT
Message-ID: <51E655D1.5020309@oracle.com>
Date: Wed, 17 Jul 2013 16:29:05 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug] label cli hangs until balance is completed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  'btrfs fi label /btrfs' will hang until balance is completed.
  (and probably even set label would hang). This is because we
  are trying to hold volume_mutex lock which balance will hold
  during its tenure.

-------
static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
::
         mutex_lock(&root->fs_info->volume_mutex);
         ret = copy_to_user(arg, label, len);
         mutex_unlock(&root->fs_info->volume_mutex);
--------

  I doubt if get label would need such a heavy weight lock?
  Do we have any other lock which could fit better here ?
  Any comments ?

Thanks,  Anand


