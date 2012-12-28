Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:40546 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab2L1RHR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 12:07:17 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: problems with dracut mounting subvols
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DDC957.9060803@parallels.com>
Date: Fri, 28 Dec 2012 10:07:14 -0700
Message-Id: <FE23DB46-81D6-4BC4-8F98-C2E5F0233ABF@colorremedies.com>
References: <5FA2C0D0-740D-4425-A099-46382311E2A3@colorremedies.com> <50DCF245.20705@parallels.com> <5EE8E8F7-4147-4DD3-A928-AEFA27CE683C@colorremedies.com> <50DDC957.9060803@parallels.com>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 28, 2012, at 9:31 AM, dima <dolenin@parallels.com> wrote:

> On 12/28/2012 10:44 AM, Chris Murphy wrote:
>> 
>> Seems dracut is creating the wrong fstab for itself, but then also can't mount it correctly manually from a shell command. When booted in rescue mode to a full system, not just a dracut shell, I can mount -o subvol=root to one mount point, and also mount -o subvol=usr to another mountpoint (within or outside the former mount point) without error.
> 
> 
> Then I guess all is fine with subvolumes and something is strange with the way fedora is handling those. Because it is the temporary ro mount that fails.
> The only thing I can recommend is to first create all needed subvolumes, then install the minimal OS manually from CLI and configure your grub and fstab by hand.
> 
> Can't really help with dracut troubleshooting..

Right that's fine. I'm just looking for a sanity check: that the dracut fstab that initiates the temporary ro mount is wrong, and then whether or not dracut should be expected to allow mounting the same /dev/ device multiple times, with different subvols, to different mount points. That first part I think is unique to Btrfs - the notion you can mount the same device multiple times. I don't know that dracut tolerates this, or even if it should.

I'm not so concerned about getting my particular system working correctly. I'm a bug magnet just trying to break stuff and hopefully file sane bug reports. The fall out of this is the user is allowed to install Fedora in this fashion, but reboot fails, so there is a bug, question is what. But it may be a question for dracut development.


Chris Murphy