Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:16031 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036Ab3KPQEb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 11:04:31 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs fi show
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <528787FB.4040100@czarc.net>
Date: Sat, 16 Nov 2013 09:04:31 -0700
Cc: Gene Czarcinski <gene@czarc.net>
Message-Id: <8A471BDA-8355-4267-BA6F-44046F6422BD@colorremedies.com>
References: <528787FB.4040100@czarc.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 16, 2013, at 7:58 AM, Gene Czarcinski <gene@czarc.net> wrote:

> I am on Fedora 20-Beta and we just updated to btrfs-progs 0.20.rc1-20131114git9f0c53f
> 
> Previously, when you did a btrfs fi show, you got a list with one output for each btrfs storage volume whether it was a single device or multi-device volume.
> 
> Now, I get multiple outputs for each storage volume.  For example, I have a system with two SSDs as one btrfs storage volume and two USB round-and-brown disks as a second btrfs storage volume.  Each has three subvols defined and mounted.
> 
> Previously, I got two outputs; one for each volume.
> 
> Now I get three outputs for the SSD storage volume and SIX outputs for the out volume.
> 
> Is this a bug or a feature?  If it is a feature, what is it telling me?

I filed a bug on it.

https://bugzilla.redhat.com/show_bug.cgi?id=1031299


Chris Murphy