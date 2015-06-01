Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54322 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbbFAR0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 13:26:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YzTTL-0002Bf-Bb
	for linux-btrfs@vger.kernel.org; Mon, 01 Jun 2015 19:25:59 +0200
Received: from exa2-in-fw-01-epn.hns.com ([139.85.223.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 19:25:59 +0200
Received: from ndbecker2 by exa2-in-fw-01-epn.hns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2015 19:25:59 +0200
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: howto create subvolume at top level?
Date: Mon, 01 Jun 2015 13:25:52 -0400
Message-ID: <mki4j1$vvo$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[nbecker@nbecker2 ~]$ sudo btrfs subvolume create /home2
Create subvolume '//home2'
[nbecker@nbecker2 ~]$ sudo btrfs subvolume list /
ID 257 gen 66376 top level 5 path root
ID 316 gen 66376 top level 257 path home2

This created home2 under root.  How do I create home2 with top level as top 
level 5, at the same level as root?

IOW:

ID 257 gen 66376 top level 5 path root
ID 316 gen 66376 top level 5 path home2

-- 
Those who fail to understand recursion are doomed to repeat it

