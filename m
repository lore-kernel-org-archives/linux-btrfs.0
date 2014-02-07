Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16958 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaBGBow (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 20:44:52 -0500
Message-ID: <52F43CF1.8020101@oracle.com>
Date: Fri, 07 Feb 2014 09:54:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Thermionix <thermionix@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: device delete missing panic
References: <52F30422.8@gmail.com> <52F3112C.3070309@oracle.com> <52F31726.7000200@gmail.com> <0C544B5C-B262-4FEB-8221-4351490E533D@colorremedies.com> <52F42331.6040008@gmail.com>
In-Reply-To: <52F42331.6040008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 > ~ # mount -o degraded,recovery /pool 

 > Killed

> Feb 07 09:53:44 store03 kernel: BUG: unable to handle kernel NULL pointer dereference at 00000050
> Feb 07 09:53:44 store03 kernel: IP: [<f834b7b7>] btrfs_sysfs_add_one+0x1a7/0x280 [btrfs]

Mostly the above Bug is fixed in the patch below..

   [RFC PATCH] btrfs: fix null pointer deference at 
btrfs_sysfs_add_one+0x105

If you are hitting the same panic again, could you test it ?

Thanks, Anand

