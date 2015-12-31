Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55137 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbbLaKZG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 05:25:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEaPo-0004Ws-I7
	for linux-btrfs@vger.kernel.org; Thu, 31 Dec 2015 11:25:04 +0100
Received: from 117.245.67.61 ([117.245.67.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 11:25:04 +0100
Received: from ahtishamwani by 117.245.67.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 11:25:04 +0100
To: linux-btrfs@vger.kernel.org
From: Ahtisham wani <ahtishamwani@gmail.com>
Subject: BTRFS File trace from superblock using memory dumps
Date: Thu, 31 Dec 2015 10:20:17 +0000 (UTC)
Message-ID: <loom.20151231T111455-536@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Respected sir,
I have been researching on how btrfs works and manages files for a long 
time. What I want to achieve here is to trace a path of a file starting 
from superblock, then to root and so on. The problem is I dont know how to 
do it. I have been using dd and hexdump but I dont know what to look for 
and where to look for. I have been able to see some fragments of 
superblock at 64K but I dont know how to use it to trace the tree of tree 
roots node or its object_id. Any help is appreciated. Thanks

