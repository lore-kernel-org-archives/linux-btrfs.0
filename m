Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:46345 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbaAOTsv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 14:48:51 -0500
Date: Wed, 15 Jan 2014 11:40:09 -0800
From: Vladi Gergov <vladi@aresgate.net>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com
Subject: 2 year old raid1 issue chunk-recovery help
Message-ID: <20140115194008.GA5425@gypsyops.denof.sin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, in 2010 i had an issue with my raid1 when one drive failed and i
added another drive to the array and tried to rebuild. Here is what bug
I hit according to Chris Mason
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06868.html

I have since updated to lastes btrfs-tools 3.12 + kernel 3.13-rc7 and
attempted an chunk recovery which failed with this
http://bpaste.net/show/168445/

If anyone can help me get at least some of the data off this bad boy it
would be great! I am cc'ing Miao since his name was thrown under the bus
in irc :). Thanks in advance!

-- 

,-| Vladi
`-| Gergov
