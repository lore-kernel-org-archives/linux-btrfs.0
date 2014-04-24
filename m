Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-4.server.virginmedia.net ([80.0.253.68]:50506
	"EHLO know-smtprelay-omc-4.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaDXGpn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 02:45:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.fire (8.14.7/8.14.5) with ESMTP id s3O6drQT022484
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 07:39:53 +0100
Message-ID: <5358B1B9.8020308@petezilla.co.uk>
Date: Thu, 24 Apr 2014 07:39:53 +0100
From: Pete <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: bedup - De-duplication and snapshots
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

I have a very slow deduplication going on on an external usb disk.  I'm
using it for backups - I rsync the relevent files to the disk and then
take a snapshot.  I then deduplicate with bedup dedup <disk-mount-point>

What I am finding is that it is reporting a deduplication between the
data on the disk and its snapshot e.g.:

Deduplicated:
-
u'/mnt/floppy/_home/ftp/pub/Linux/Slackware/slackware-current/slackware/t/tetex-3.0-i486-7.txz'
-
u'/mnt/floppy/snapshots/_home_20131205T15:02:33/ftp/pub/Linux/Slackware/slackware32-13.37/slackware/t/tetex-3.0-i486-7.txz'

(don't worry, I promise it is an external usb drive and not a floppy!)

However, I thought that would not be necessary as one would merely be a
snapshot of the other.  Running 3.13.6.  Unfortunately bedup does not
give a version number.

kind regards,

Pete

