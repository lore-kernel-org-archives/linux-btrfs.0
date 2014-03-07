Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:44931 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaCGPOS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 10:14:18 -0500
Date: Fri, 7 Mar 2014 16:14:16 +0100
From: Sander <sander@humilis.net>
To: Eric Mesa <ericsbinaryworld@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups
Message-ID: <20140307151416.GA29687@panda>
Reply-To: sander@humilis.net
References: <loom.20140306T191655-366@post.gmane.org>
 <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
 <loom.20140307T144540-512@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20140307T144540-512@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Mesa wrote (ao):
> Duncan - thanks for this comprehensive explanation. For a huge portion of
> your reply...I was all wondering why you and others were saying snapshots
> aren't backups. They certainly SEEMED like backups. But now I see that the
> problem is one of precise terminology vs colloquialisms. In other words,
> snapsshots are not backups in and of themselves. They are like Mac's Time
> Machine. BUT if you take these snapshots and then put them on another media
> - whether that's local or not - THEN you have backups. Am I right, or am I
> still missing something subtle? 

Snapshots are backups, but only protect you against a limited amount of
disasters. Snapshots are very convenient to quickly go back in time for
some or all files and directories. But if the filesystem or underlaying
disk goes up in flames, the snapshots are toast as well. So you need
additional backups, preferably not on the same hardware, for real
protection against data loss.

The convenience of snapshots is that you can (almost) make them as often
as you want, fully automated, with (almost) no impact on performance,
without the need for extra hardware, and a restore is no more than a
simple copy.

	Sander
