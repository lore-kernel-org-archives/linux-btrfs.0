Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37600 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbbDXHmG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 03:42:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlYFI-00009Y-EA
	for linux-btrfs@vger.kernel.org; Fri, 24 Apr 2015 09:41:56 +0200
Received: from 168.159.160.58 ([168.159.160.58])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 09:41:56 +0200
Received: from toyours_sridhar by 168.159.160.58 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 09:41:56 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs send dump format
Date: Fri, 24 Apr 2015 07:41:49 +0000 (UTC)
Message-ID: <loom.20150424T094126-341@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is there any document or something to understand btrfs send format/layout 
i.e being created when we give a file with -f option. 

I looking for it in order to create similar dump file with same layout so 
that I can use btrfs receive with the dump file which I have created in 
order to receive files form dump.

