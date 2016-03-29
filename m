Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:38683
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbcC2Lrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 07:47:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2TBlSHb032273
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 12:47:28 +0100
To: linux-btrfs@vger.kernel.org
From: Pete <pete@petezilla.co.uk>
Subject: System very unresponsive during btrfs device delete - can it be
 paused?
Message-ID: <56FA6B50.4060505@petezilla.co.uk>
Date: Tue, 29 Mar 2016 12:47:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am deleting a drive using btrfs device delete <dev> </path>.  The
system is very unresponsive, it can be unresponsive for periods of
around 10 seconds, windows not refreshing, not responding to the
keyboard for example.  Suspect it is why printing is not working at
present.  Is there anyway of pausing or cancelling so I can get stuff
done?  Rebooting seems to work but I was looking for something less
blunt?  Any way of lowering the priority of the delete.

This would not be so frustrating if the delete did not take multiple days.

Pete
