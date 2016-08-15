Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1.edulibre.org ([5.39.16.54]:59217 "EHLO mail.edulibre.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbcHOT4O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 15:56:14 -0400
Received: from asus17.lairdutemps.org (did75-10-82-236-230-93.fbx.proxad.net [82.236.230.93])
	by mail.edulibre.org (Postfix) with ESMTPSA id 2D2B41026A89
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 21:56:11 +0200 (CEST)
Date: Mon, 15 Aug 2016 21:56:10 +0200
From: Daniel Caillibaud <ml@lairdutemps.org>
To: btrfs ml <linux-btrfs@vger.kernel.org>
Subject: Re: Huge load on btrfs subvolume delete
Message-ID: <20160815215610.4f10d4ba@asus17.lairdutemps.org>
In-Reply-To: <5b02565e-95b2-cc9d-154f-b9e8805dbed4@gmail.com>
References: <20160815123928.47bd2c03@asus17.lairdutemps.org>
	<95c98a1b-4484-c294-fcd6-001e73cd25d6@gmail.com>
	<20160815160641.79063cec@asus17.lairdutemps.org>
	<5b02565e-95b2-cc9d-154f-b9e8805dbed4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 15/08/16 à 10:16, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> a écrit :
ASH> With respect to databases, you might consider backing them up separately 
ASH> too.  In many cases for something like an SQL database, it's a lot more 
ASH> flexible to have a dump of the database as a backup than it is to have 
ASH> the database files themselves, because it decouples it from the 
ASH> filesystem level layout.

With mysql|mariadb, having a consistent dump needs to lock tables during dump, not acceptable on
production servers. 

Even with specialised tools for hotdump, doing the dump on prod servers is too heavy about I/O
(I have huge db, writing the dump is expensive and long).

I used to have a slave juste for the dump (easy to stop slave, dump, and start slave), but after
a while it wasn't able to follow the writings all the day long (prod was on ssd and it wasn't,
dump hd was 100% busy all the day long), so it's for me really easier to rsync the raw
files once a day on a cheap host before dump.

(of course, I need to flush & lock table during the snapshot, before rsync, but it's just one or
two seconds, still acceptable)

-- 
Daniel
