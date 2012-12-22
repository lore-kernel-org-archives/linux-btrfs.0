Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43774 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237Ab2LVXBZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Dec 2012 18:01:25 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50D5B92D.105@czarc.net>
Date: Sat, 22 Dec 2012 16:01:23 -0700
Message-Id: <C70342D5-1344-41F8-8D16-39CA3E25666E@colorremedies.com>
References: <50D5B92D.105@czarc.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 22, 2012, at 6:44 AM, Gene Czarcinski <gene@czarc.net> wrote:

> I am new to btrfs and have begun exploring and testing it.  One of these tests is to install Fedora 18 into a btrfs volume only leaving /boot and swap on regular partitions.  BTW, this is on qemu/kvm/libvirt virtuals.
> 
> I discovered an error was occurring during bootup because systemd was attempting to start fsck.btrfs and it was missing.
> 
> 1. Would btrfsck be the appropriate program to run at bootup?  If it is, with what parameters?

I'd check /etc/fstab. I'm pretty sure at the moment most distros including Fedora are defaulting to fstab options 1 1 for btrfs which causes the described behavior. I have filed a Fedora bug against the installer which is responsible for creating fstab.

https://bugzilla.redhat.com/show_bug.cgi?id=862871



Chris Murphy