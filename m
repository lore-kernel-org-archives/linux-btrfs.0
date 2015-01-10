Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49452 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbAJKl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 05:41:59 -0500
Received: from merkaba.localnet (host-188-174-199-142.customer.m-online.net [188.174.199.142])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 23A02CB
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 11:40:42 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Autodefrag option with more delay?
Date: Sat, 10 Jan 2015 11:41:57 +0100
Message-ID: <24952376.hEFToVtt8e@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On answering to the nocow file bit thread I wondered about the way autodefrag 
works. As I saw quite some time ago with a VM image on a 2,5 inch external 
eSATA harddisk it kicks in quite quickly and seems to cause a *lot* of 
additional writes.

I wonder about this case:

merkaba:/home/martin/.local/share/akonadi/db_data/akonadi> filefrag 
parttable.ibd
parttable.ibd: 8039 extents found

Akonadi stores metadata about parts, like mails, contacts and so on in there. 
Now the most regular workload for this with a mail setup like here is:

Add new data.

It may not change much of the data after all the filtering of the mail to their 
mailfolders have done. Similarily with VM images after installation, much of 
the image may not be touched anymore then.

I wonder how autodefrag would perform when it would take the *write hotness* 
of data into account. I.e. only kick in after data has cooled down a bit. That 
could help for any cases where applications only modify recently written data 
and leave older cold data alone. And I bet there may be quite some 
applications doing that. Including, but not limited to journald.

I bet it may do so already to some extent, but I also get the impression it 
probably doesn´t wait long enough for the data to cool down and kicks in too 
quickly. I bet it could be beneficial for it to be a bit more lazy.

In the end if could even be lazy enough to wait till data is actually read 
accessed in a way that causes delays. So it could postpone the defragmentation 
still someone actually makes use of the written data. Of course that would 
only optimize frequent accesses, first time accesses would be slower.

On the other hands more heuristics adds more complexity and may break stuff as 
well.

What do you think?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
