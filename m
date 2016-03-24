Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:40410
	"EHLO know-smtprelay-omc-3.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcCXTvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 15:51:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2OJpTWe011964
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 19:51:29 GMT
To: linux-btrfs@vger.kernel.org
From: Pete <pete@petezilla.co.uk>
Subject: Slow delete and shutdown
Message-ID: <56F44541.5090003@petezilla.co.uk>
Date: Thu, 24 Mar 2016 19:51:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I'm replacing a disk in my system.  I've added the new drive and I'm
deleting one which is causing data to be written to the new drive.
However, progress is painfully slow.  150GB of approx. 1.8TB written to
new disk in about 12 hours. SO about 6 days to go.  I know it is a slow
process but this seems excessive.

I want to shut down the system in this period, would that be OK?  Will
it resume on boot or would I just re-issue the delete command?

Pete


