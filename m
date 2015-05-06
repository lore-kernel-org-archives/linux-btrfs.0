Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37417 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbbEFVgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 17:36:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yq6zM-0007nH-BT
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 23:36:20 +0200
Received: from c-50-164-174-197.hsd1.ma.comcast.net ([50.164.174.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 23:36:20 +0200
Received: from cdysthe by c-50-164-174-197.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 23:36:20 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: fstrim and subvolumes.
Date: Wed, 06 May 2015 17:36:12 -0400
Message-ID: <mie1ge$3to$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use a script to run scheduled fstrims on my SSD. I have a small /boot 
partition ext4 and a large btrfs partition / with /home as a subvolume of /

My question is simple if I run "fstrim /" will /home be trimmed as well 
or will i have to run "fstrim /home" also to get the whole partition 
trimmed?

-- 
//Christian


