Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56888 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaCABVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 20:21:44 -0500
Received: from [192.168.0.102] ([130.180.1.21]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MPlsg-1WFgk03jpS-004za8 for
 <linux-btrfs@vger.kernel.org>; Sat, 01 Mar 2014 02:21:42 +0100
Message-ID: <53113626.3060706@gmx.net>
Date: Sat, 01 Mar 2014 02:21:42 +0100
From: Marcel Partap <mpartap@gmx.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to view transaction log chronologically, human-readable?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTFRS devs,
I have a 1TB btrfs volume mounted read-only since two years because I
deleted a bunch of files and didn't want to give up on them.
Now with latest btrfs-find-root and btrfs restore --dry-run -t in a
loop, I generated the full list of files contained in the last several
hundred root trees. However, diffing these, I find the current one being
the same until 94 root trees back, and the ones before contain earlier
changes. Maybe by my own fault that is..whatever.

Is there a way to just view the transaction history in a human-readable way?

#Regards
