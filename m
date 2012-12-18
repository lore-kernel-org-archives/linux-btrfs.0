Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2LRDGK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 22:06:10 -0500
Message-ID: <50CFDD8E.2050003@oracle.com>
Date: Tue, 18 Dec 2012 11:05:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com, miaox@cn.fujitsu.com, kreijack@inwind.it
Subject: [RFC PATCH V6 0/2] Btrfs: get/set label of a mounted file system
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is quick fix for btrfs set lable ioctl(2) based on v5, it does label length check up with
strnlen() to avoid searching a zero could go beyond the page limit touching an un-mapped page
and raising an segmentation fault with strlen().


V6->v5:
- Improve the input label string validation with strnlen().


The old versions can be found at:
v5:
http://www.spinics.net/lists/linux-btrfs/msg20888.html

v4:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21618

v3:
https://patchwork.kernel.org/patch/1124642/

v2:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12877

v1:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12872

Thanks,
-Jeff
