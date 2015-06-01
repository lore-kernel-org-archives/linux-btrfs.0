Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59879 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbbFAMgu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 08:36:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzOxS-00072d-Vt
	for linux-btrfs@vger.kernel.org; Mon, 01 Jun 2015 14:36:47 +0200
Received: from exa2-in-fw-01-epn.hns.com ([139.85.223.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 14:36:46 +0200
Received: from ndbecker2 by exa2-in-fw-01-epn.hns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 14:36:46 +0200
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: [newb] move /home to subvolume
Date: Mon, 01 Jun 2015 08:36:40 -0400
Message-ID: <mkhjkp$hgl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have everything under /:

sudo btrfs subvolume list /
ID 257 gen 65795 top level 5 path root

I want to move /home onto it's own subvolume.  I hope I can do this while 
the root device is mounted.

What is the procedure?

I tried first to create a subvolume for /home at the top-level, but couldn't 
figure out the syntax:

[nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home
[sudo] password for nbecker: 
ERROR: '/home' exists

-- 
Those who fail to understand recursion are doomed to repeat it

