Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:36295 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab2LHWQq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Dec 2012 17:16:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Help with corrupt filesystem: __btrfs_free_extent:5236: IO failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com>
Date: Sat, 8 Dec 2012 15:16:44 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C0EB710E-B446-4B43-911C-6FDE96E74170@colorremedies.com>
References: <20121208161653.GA31750@lintop> <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 8, 2012, at 2:21 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> So am I screwed?  I suppose since the drives do mount read only I
>> should be able to copy all of the salvageable data to some new drives.
>> Is this my only option?
> 
> Your next step depends on whether you have a backup of the data or not, and it sounds like you're playing with an experimental file system without a backup. If that's true and the data is important I'd block copy each disk independently to new disks, before you do anything else.

In the meantime, you could also do a smartctl -x /dev/sdX or smartctl -a /dev/sdX on each drive and post that, which should give some indication if there are bad sectors or other big problems happening. i'd probably avoid doing any -t tests until you have backups in case one or both drives are in the process of imploding.


Chris Murphy

