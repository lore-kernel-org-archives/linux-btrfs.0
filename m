Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab2IKRZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 13:25:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TBUCu-0003Rr-3t
	for linux-btrfs@vger.kernel.org; Tue, 11 Sep 2012 19:25:04 +0200
Received: from wpis-64-140-209-221.worldpath.net ([64.140.209.221])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 19:25:04 +0200
Received: from caleb by wpis-64-140-209-221.worldpath.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 19:25:04 +0200
To: linux-btrfs@vger.kernel.org
From: "Caleb O'Connell" <caleb@privacyassociation.org>
Subject: advice for testing fileserver
Date: Tue, 11 Sep 2012 13:19:47 -0400
Message-ID: <k2nrrj$voq$1@ger.gmane.org>
Reply-To: caleb@privacyassociation.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm building a test file server using samba 3.6 to see if BTRFS is a good 
fit.  I want to stress that this is a test setup for now.

I'm trying to get an idea of the sub-volume concept and how it relates to 
the LVM concept.  Trying to see what might be the best practice.

I was going to create one of two configs.
-----------------------------------------------------------------------------
##
option 1
sda1 -> /boot using ext4
sda2 is LV sysvg, this will include:
  lvroot -> / using ext4
  lvvar -> /var using ext4
  lvopt -> /opt using ext4
  lvhome -> /home using btrfs
  lvsrv -> /srv using btrfs

I could create sub-volumes in srv for each samba share.

##
option 2
sda1 -> /boot using ext4
sda2 is LV sysvg, this will include:
  lvroot -> / using ext4
  lvvar -> /var using ext4
  lvopt -> /opt using ext4
sda3 -> /home using btrfs
sda4 -> /srv using btrfs

both /home and /srv can create their own sub-volumes for each homedir and 
each share.
____________________________________________________________________________
Does BTRFS work fine within a LV?  Is there an advantage to keep BTRDS out 
or in a LV?  Does all this make no sense? and I really should just create 
one big BTRFS partition and only use sub-volumes?



