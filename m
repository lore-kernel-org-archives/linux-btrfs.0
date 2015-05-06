Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51800 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbbEFRom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 13:44:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yq3N5-0003eM-9p
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 19:44:35 +0200
Received: from exa2-in-fw-01-epn.hns.com ([139.85.223.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 19:44:35 +0200
Received: from ndbecker2 by exa2-in-fw-01-epn.hns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 19:44:35 +0200
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: btrfs device scan returns nothing?
Date: Wed, 06 May 2015 13:44:29 -0400
Message-ID: <midjtt$s4f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What am I doing wrong?

sudo btrfs device scan

Scanning for Btrfs filesystems
[silence]

But I'm running on btrfs now:

--- /etc/fstab
UUID=7246327b-1905-4fe2-9b6b-b9376017264f /                       btrfs   
subvol=root     1 1
UUID=2c04be93-34c1-4016-ba41-60fd9fd90616 /boot                   ext4    
defaults        1 2
UUID=7246327b-1905-4fe2-9b6b-b9376017264f /home                   btrfs   
subvol=home     1 2
...
-- 
Those who fail to understand recursion are doomed to repeat it

