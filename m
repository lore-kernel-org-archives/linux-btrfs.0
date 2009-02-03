From: Chris Mason <chris.mason@oracle.com>
Subject: Re: More performance results
Date: Tue, 03 Feb 2009 10:01:36 -0500
Message-ID: <1233673296.7246.4.camel@think.oraclecorp.com>
References: <49871813.8090309@austin.ibm.com>
	 <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steven Pratt <slpratt@austin.ibm.com>, linux-btrfs@vger.kernel.org
To: debian developer <debiandev@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 19:02 +0530, debian developer wrote:
> On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
> >
> > Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
> >
> > Single disk results are not too bad.  Raid still falls apart on any write heavy workload.
> 
> Would you please mind explaining how bad the results are and
> how much more this needs to be improved for Btrfs to be perfomance
> wise acceptable?
> 
> I see that Btrfs almost everywhere lacks XFS and others in some cases.

These benchmarks are great because they hammer on some of the worst
cases code in btrfs.  The mail-server benchmark for example isn't quite
a mail server workload because it doesn't fsync the files to disk.

But what it does do is hammer on a mixed file read/write/delete
workload, which hits btree concurrency and file layout.  In my testing
here, the big difference between ext4 and btrfs isn't writing to files,
it is actually the unlinks.  If I take them out of the run, btrfs is
very close to ext4 times.

So, I'm working on that.

The random write workload is probably just a file allocation problem.
Btrfs should be perform very well in that workload.

-chris




