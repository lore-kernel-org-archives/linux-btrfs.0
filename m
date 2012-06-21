Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:55326 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2FUUF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 16:05:59 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <harald@redhat.com>
Subject: [RFC] A way to tell if all the devices in a file system are available
Date: Thu, 21 Jun 2012 16:10:29 -0400
Message-ID: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Harald Hoyer has had this as a feature request for ages and I've finally gotten
around to hacking something up.  This is probably going to get bikeshedded to
death, bring it on, I'm not married to any of the behaviors in these patches, I
just want to get the ball rolling so we can have something in place for 3.6.

Basically all I've done is saved how many devices the super block thinks we have
into the fs_devices struct whenever we scan a device.  Then all we have to do
for the IOCTL is compare how many devices the fs_devices struct has in it to how
many we think we need.

The command itself just spits out 0 for yay we're ready and 1 for boo no we're
not.  This makes it easier for Harald to do his multi-device btrfs support in
dracut.  Thanks,

Josef
