Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40623 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFEKyc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 06:54:32 -0400
From: Russell Coker <russell@coker.com.au>
To: Igor M <igork20@gmail.com>
Reply-To: russell@coker.com.au
Cc: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Very slow filesystem
Date: Thu, 05 Jun 2014 20:54:27 +1000
Message-ID: <1967972.kDBB8dC4mO@xev>
In-Reply-To: <CAEezp7sahY+hcKpu=aLA0T81UWjujRoxP465jBmQrr31ESB2qg@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com> <pan$765af$b28af9a8$903ce16b$940baf34@cox.net> <CAEezp7sahY+hcKpu=aLA0T81UWjujRoxP465jBmQrr31ESB2qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 5 Jun 2014 09:50:53 Igor M wrote:
> But data to this big tables is only appended, it's never deleted. So
> no rewrites should be happening.

When you write to the big tables the indexes will be rewritten.  Indexes can 
be in the same file as table data or as separate files depending on what data 
base you use.  For the former you get fragmented table files and for the 
latter 70G of data will have index files that are large enough to get 
fragmented.

Also when you have multiple files in a filesystem being written at the same 
time (EG multiple tables appended to in each transaction) then you will get 
some fragmentation.  Add COW and that makes a lot of fragmentation.

Finally append is done at the file level while COW is rewriting at the block 
level.  If your database rounds up the allocated space to some power of 2 
larger than 4K then things will be fine for a filesystem like Ext3 where file 
offsets correspond to fixed locations on disk.  But with BTRFS that pre-
allocated space filled with zeros will be rewritten to a different part of 
disk when the allocated space is used.

If you use a database that doesn't preallocate space then COW will be invoked 
when the end of the file at an offset that isn't a multiple of 4K (or I think 
16K for a BTRFS filesystem created with a recent mkfs.btrfs) is written as 
appending to data within a block offset means rewriting the block.

I believe that COW is desirable for a database.  I don't believe that a lack 
of integrity at the filesystem level will help integrity at the database 
level.  If the working set of your database can fit in RAM then you can rely 
on cache to ensure that little data is read during operation.  For example one 
of my database servers has been running for 330 days and the /mysql filesystem 
has writes outnumbering reads by a factor of 3:1.  When most IO is for writes 
fragmentation of data is less of an issue - although in this case the server 
is running Ext3 so it wouldn't get the COW fragmentation issues.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

