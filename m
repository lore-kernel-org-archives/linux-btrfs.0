Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38138 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbcDRHYf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 03:24:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1as3Xn-0005yj-ON
	for linux-btrfs@vger.kernel.org; Mon, 18 Apr 2016 09:24:33 +0200
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 09:24:22 +0200
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 09:24:22 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: btrfs-image and btrfs send related queries
Date: Mon, 18 Apr 2016 07:24:16 +0000 (UTC)
Message-ID: <loom.20160418T092105-74@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>
 <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>

I tried btrfs-image and created image file and ran btrfs-image -r to a 
different disk. Once recovered and mounted, I can able to see data is 
not zeroed out as mentioned in btrfs-image man page.

I tried on same machine.

