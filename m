Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762044Ab2FVKeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 06:34:06 -0400
Message-ID: <4FE44A17.9070109@redhat.com>
Date: Fri, 22 Jun 2012 12:33:59 +0200
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

On 06/21/2012 10:10 PM, Josef Bacik wrote:
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

Exactly what I need! Thanks! Would be really usefu!

