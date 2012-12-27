Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:51853
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab2L0QHX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 11:07:23 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Another novice question & comment
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DC5B51.9060506@czarc.net>
Date: Thu, 27 Dec 2012 09:07:22 -0700
Message-Id: <0290535D-CBF3-4059-AEF8-3E3A64ABC223@colorremedies.com>
References: <50DC5B51.9060506@czarc.net>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 7:29 AM, Gene Czarcinski <gene@czarc.net> wrote:

> OK, this is from inside a shell.  I have a btrfs volume or a btrfs subvolume on some arbitrary mount mount.  Is there some way to tell if it is a btrfs volume or a btrfs subvolume that is mounted?

cat /proc/self/mountinfo | grep btrfs

That will show you what subvol is mounted and where, subvol is the 4th column, mountpoint is the fifth.



Chris Murphy

