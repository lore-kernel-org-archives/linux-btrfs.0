Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2GJRfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 13:35:44 -0400
Message-ID: <4FFC67ED.2070104@redhat.com>
Date: Tue, 10 Jul 2012 19:35:41 +0200
From: Harald Hoyer <harald@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] A way to tell if all the devices in a file system are available
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340309431-9972-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 21.06.2012 22:10, schrieb Josef Bacik:
> Harald Hoyer has had this as a feature request for ages and I've finally gotten
> around to hacking something up.  This is probably going to get bikeshedded to
> death, bring it on, I'm not married to any of the behaviors in these patches, I
> just want to get the ball rolling so we can have something in place for 3.6.
> 
> Basically all I've done is saved how many devices the super block thinks we have
> into the fs_devices struct whenever we scan a device.  Then all we have to do
> for the IOCTL is compare how many devices the fs_devices struct has in it to how
> many we think we need.
> 
> The command itself just spits out 0 for yay we're ready and 1 for boo no we're
> not.  This makes it easier for Harald to do his multi-device btrfs support in
> dracut.  Thanks,
> 
> Josef
> 

any news on this?

