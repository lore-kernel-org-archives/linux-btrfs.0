Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from neo-zeon.de ([173.228.7.145]:47882 "EHLO neo-zeon.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbbD2VqA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 17:46:00 -0400
Received: from [192.168.74.143] ([97.64.124.16])
	(authenticated bits=0)
	by neo-zeon.de (8.14.9/8.14.9) with ESMTP id t3TLjvna001321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 14:45:58 -0700 (PDT)
	(envelope-from cam@neo-zeon.de)
Message-ID: <55415110.9010609@neo-zeon.de>
Date: Wed, 29 Apr 2015 14:45:52 -0700
From: Cameron Berkenpas <cam@neo-zeon.de>
MIME-Version: 1.0
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: btrfs quota questions
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've successfully enabled quotas/qgroups in btrfs. I've also managed to 
set a limit on a subvolume.

I have 2 questions:

1. Is there a command to retrieve the current quota limit set on a 
subvolume? It seems odd that I can set a limit on a subvolume, but I 
can't find out what that limit is.

2. When using "btrfs qgroup show <path>", EVERY subvolume on the device 
is listed. Is it possible to only list the subvolume given in the path?

Ie, "btrfs qgroup show /home" would only show quota information for /home.

Thanks!

-Cameron



