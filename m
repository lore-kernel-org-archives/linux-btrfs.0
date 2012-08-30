Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:47624 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2H3G1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 02:27:14 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7U6RBUO029662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 06:27:12 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7U6RAsx014726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 06:27:11 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7U6RAFC027863
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2012 01:27:10 -0500
Message-ID: <503F082A.4070603@oracle.com>
Date: Thu, 30 Aug 2012 14:28:58 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Jie Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Add get/set label ioctl
References: <1346229961-635-1-git-send-email-Anand.Jain@oracle.com> <503DDA25.1020407@oracle.com> <503EC7F0.2020305@oracle.com> <503EFDBA.8030707@oracle.com> <503F005E.1060908@oracle.com>
In-Reply-To: <503F005E.1060908@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The original patch could be revised with this support easily.
> How about using one structure and one ioctl number for both of them? i.e,
>
> #define BTRFS_IOC_FSLABEL_CTL    _IOW(BTRFS_IOCTL_MAGIC, 50, struct
> btrfs_ioctl_fslabel_ctl_args)
>
> #define BTRFS_FSLABEL_CTL_GET    0
> #define BTRFS_FSLABEL_CTL_SET    1
>
> struct btrfs_ioctl_fslabel_ctl_args {
>          char label[BTRFS_LABEL_SIZE];
>          u32  flags;
> };
>
> so that get/set label from user tools would looks like,
>
> struct btrfs_ioctl_fslabel_ctl_args arg;
> arg.flags = BTRFS_FSLABEL_CTL_GET;  /* get label */
> or
> arg.flags = BTRFS_FSLABEL_CTL_SET; /* set label */
> ....
>
> ioctl(fd, BTRFS_FSLABEL_CTL,&arg);


  I would prefer separating GET and SET label ioctl,
  (to have one operation with an ioctl define) that
  will be similar to rest of the ioctl in btrfs.
  Further we don't need ioctl-arg-struct here, unless
  if you are keeping the flags.

  And in my understanding in kernel memcpy are better
  instead of strcpy.
  
  If you could add GET that will be nicer.

  I would need this for an experiment to add the label
  for the subvol/snapshots.

Thanks, Anand
