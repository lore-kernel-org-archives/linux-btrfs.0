Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33498 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaENBZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 May 2014 21:25:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WkNwN-0000q2-6r
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 03:25:03 +0200
Received: from 187.113.203.79 ([187.113.203.79])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 03:25:03 +0200
Received: from bcdonadio by 187.113.203.79 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 03:25:03 +0200
To: linux-btrfs@vger.kernel.org
From: Bernardo Donadio <bcdonadio@gmail.com>
Subject: lsetxattr error when doing send/receive
Date: Tue, 13 May 2014 20:44:44 -0300
Message-ID: <lkuapc$si7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm trying to do a send/receive of a snapshot between two disks on 
Fedora 20 with Linux 3.15-rc5 (and also tried with 3.14 and 3.11) and 
SELinux disabled, and then I'm receiving the following error:

[root@darwin /]# btrfs subvolume snapshot -r / @.$(date 
+%Y-%m-%d-%H%M%S)Create a readonly snapshot of '/' in 
'./@.2014-05-13-203532'
[root@darwin /]# btrfs send @.2014-05-13-203532 | btrfs receive /mnt/cold/
At subvol @.2014-05-13-203532
At subvol @.2014-05-13-203532
ERROR: lsetxattr bin security.selinux=system_u:object_r:bin_t:s0 failed. 
Operation not supported

I'm missing something? Is this a bug?

--
Bernardo Donadio

