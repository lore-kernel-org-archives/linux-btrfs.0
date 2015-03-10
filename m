Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51467 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbCJTKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 15:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YVPXY-00063B-Dz
	for linux-btrfs@vger.kernel.org; Tue, 10 Mar 2015 20:10:04 +0100
Received: from 197.253.187.81.in-addr.arpa ([81.187.253.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 20:10:04 +0100
Received: from richardm by 197.253.187.81.in-addr.arpa with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 20:10:04 +0100
To: linux-btrfs@vger.kernel.org
From: Richard Melville <richardm@cellularity.co.uk>
Subject: "some devices missing" after scrub and btrfs upgrade.
Date: Tue, 10 Mar 2015 19:03:31 +0000 (UTC)
Message-ID: <loom.20150310T194713-251@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm looking for advice on the best way to proceed.  I have a two-disk raid 1 
btrfs root file system into which the box boots.  The file system became 
corrupted to the point where I was unable to boot into it.  Using my rescue 
system I ran scrub which seemed to sort out the problem.  I can now boot into 
the raid and the data appears to be intact.  I have now upgraded to kernel 
version 3.19.1 with the accompanying latest btrfs-progs.  Even though the 
data still appears to be accessible, when I run "btrfs fi show" only one disk 
is listed along with the message "some devices missing". 

