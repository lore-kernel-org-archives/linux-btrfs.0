Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57216 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbAJKvE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 05:51:04 -0500
Received: from merkaba.localnet (host-188-174-199-142.customer.m-online.net [188.174.199.142])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B505A195
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 11:49:47 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Autodefrag option with more delay?
Date: Sat, 10 Jan 2015 11:51:02 +0100
Message-ID: <1939485.9eHmoT5uad@merkaba>
In-Reply-To: <24952376.hEFToVtt8e@merkaba>
References: <24952376.hEFToVtt8e@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 10. Januar 2015, 11:41:57 schrieb Martin Steigerwald:
> Hi!
> 
> On answering to the nocow file bit thread I wondered about the way
> autodefrag works. As I saw quite some time ago with a VM image on a 2,5
> inch external eSATA harddisk it kicks in quite quickly and seems to cause a
> *lot* of additional writes.
> 
> I wonder about this case:
> 
> merkaba:/home/martin/.local/share/akonadi/db_data/akonadi> filefrag
> parttable.ibd
> parttable.ibd: 8039 extents found
> 
> Akonadi stores metadata about parts, like mails, contacts and so on in
> there. Now the most regular workload for this with a mail setup like here
> is:
> 
> Add new data.
> 
> It may not change much of the data after all the filtering of the mail to
> their mailfolders have done. Similarily with VM images after installation,
> much of the image may not be touched anymore then.
> 
> I wonder how autodefrag would perform when it would take the *write hotness*
> of data into account. I.e. only kick in after data has cooled down a bit.
> That could help for any cases where applications only modify recently
> written data and leave older cold data alone. And I bet there may be quite
> some applications doing that. Including, but not limited to journald.

Okay, nope. Not journald, as, as far as I understand it it would never leave 
the beginning of the file alone when it still writes to it. As MySQL would, I 
think, just write into certain parts of the database file, i.e. there where it 
would add the new records, as AFAIK MySQL stores the index seperate from the 
tables if you use innodb_file_per_table.

I have seen fluentd tail plugin using a position file to track the position in 
text based logfiles. It uses an external file as to not modify the logfile of the 
application or syslog daemon. But actually writing the position pointers into 
an external files IMHO makes a huge lot of sense for a copy on write filesystems 
like BTRFS.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
