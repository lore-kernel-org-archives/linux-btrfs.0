Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13595
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2LERV0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 12:21:26 -0500
From: Thorn Roby <Thorn.Roby@harlandfs.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Mounted compress-force=zlib, compresses when files copied in,
 but not when written directly by application
Date: Wed, 5 Dec 2012 17:21:17 +0000
Message-ID: <6726B0D4C83B3047A636A714BAB0B92306C574@DSM-SRV-MBX2.harlandfs.com>
References: <loom.20121204T201625-335@post.gmane.org>
 <20121205020131.GA5204@liubo>
In-Reply-To: <20121205020131.GA5204@liubo>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your response. Yes, the rsync copies a number of the 2GB files written by the same database software on another system on XFS, and compression is successful. These files consist mostly of plain text log output and are highly compressible (4:1 via zlib). When the database is running locally on btrfs, the I/O pattern is that the database allocates a new 2GB datafile (perhaps using a sparse allocation call, I know it does on XFS) and then says it fills the file with zeroes (but I'm not certain this actually happens). At that point database inserts are appended initially to a transaction log (a separate non-sparse 2GB file), and shortly thereafter there is a batch copy operation (I'm not sure of the size) of a set of new rows which are copied from the transaction log and appended to the main datafiles (which are sparse). Up until now I have included both the transaction log and the datafiles within the btrfs filesystem - next I'm going to try putting the transaction log on a separate filesystem . The btrfs fi df output was taken after the database load process was stopped, so it reflects a static set of the 2GB datafiles (plus the transaction log and a few other database system files).

-----Original Message-----
From: Liu Bo [mailto:bo.li.liu@oracle.com] 
Sent: Tuesday, December 04, 2012 7:02 PM
To: Thorn Roby
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Mounted compress-force=zlib, compresses when files copied in, but not when written directly by application


Well, it shouldn't be that since we have compress-force, as the name shows, with compress-force it'll always try to compress the data via zlib/lzo.

So the previous rsync one is just 'write numbers of 2G files', while the current application one is 'write numbers of 2G files' plus 'overwritten by others later', is it right?

And is the above 'btrfs fi df' output captured after 'overwritten', or not?

thanks,


