Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:56122 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3F3N47 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 09:56:59 -0400
Received: from homiemail-a45.g.dreamhost.com (caibbdcaaaaf.dreamhost.com [208.113.200.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id A6DD2DDC96
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 06:56:59 -0700 (PDT)
Received: from homiemail-a45.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a45.g.dreamhost.com (Postfix) with ESMTP id D5EDD4809C
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 06:56:19 -0700 (PDT)
Received: from bheem.localnet (unknown [49.248.66.59])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ghodechhap@ghodechhap.net)
	by homiemail-a45.g.dreamhost.com (Postfix) with ESMTPSA id 788CA480A1
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 06:56:19 -0700 (PDT)
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: linux-btrfs@vger.kernel.org
Subject: unclean shutdown and space cache rebuild
Date: Sun, 30 Jun 2013 19:26:16 +0530
Message-ID: <11441914.sRzrmH57Vq@bheem>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have 3 partitions with btrfs(/, /home and /data). All of them have following 
mount options

noatime,space_cache,inode_cache,compress=lzo,defaults

Whenever there is a unclean shutdown(which happens a lot in my case), the next 
reboot, system comes up relatively at the same speed but as systemd is 
starting up daemons, the disk is continuously ( and unusally long) grinding.

This causes random delays with various daemons such as postgresql failing to 
start, kdm timing out of xorg servers etc and I have to reboot after the dust 
settles to bring back the system to the normal. At one time, even 
keyboad/mouse were not responding as some debus service timed out..

I think it is rebuilding the space cache because I saw similar long disk 
activity when I activated it first.

How can I confirm that it is the space cache rebuild thats taking time?

if space cache rebuild is the reason, is there any way to improve it? 

I am running archlinux/systemd/kde setup with two 7200 RPM seagate sata 
disks(no RAID, one 80 GB for / and /home, other 500GB for data). The kernel is 
3.9.8 x86_64.

Thanks.

-- 
Regards
 Shridhar
