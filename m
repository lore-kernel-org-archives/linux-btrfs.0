Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:49141 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3KVNym (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 08:54:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 3487915281
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 13:47:52 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id IN9aZyDibGcc for <linux-btrfs@vger.kernel.org>;
	Fri, 22 Nov 2013 13:47:50 +0000 (GMT)
Message-ID: <528F6085.4020603@pocock.com.au>
Date: Fri, 22 Nov 2013 14:47:49 +0100
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Nagios probe for btrfs RAID status?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I just did a search and couldn't find any probe for btrfs RAID status

The "check_raid" plugin seems to recognise mdadm and various other types
of RAID but not btrfs

Has anybody seen a plugin for Nagios or could anybody comment on how it
should work if somebody wants to make one?

For example, would the command

    btrfs filesystem show --all-devices

give a non-zero error status or some other clue if any of the devices
are at risk?


