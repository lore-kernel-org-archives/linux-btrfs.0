From: Heinz-Josef Claes <hjclaes@web.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 22:36:07 +0200
Message-ID: <200904282236.07428.hjclaes@web.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <200904281945.10274.hjclaes@web.de> <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 28. April 2009 22:16:19 schrieb Thomas Glanzmann:
> Hello Heinz,
>
> > It's not only cpu time, it's also memory. You need 32 byte for each 4k
> > block.  It needs to be in RAM for performance reason.
>
> exactly and that is not going to scale.
>
>         Thomas


Hi Thomas,

I wrote a backup tool which uses dedup, so I know a little bit about the 
problem and the performance impact if the checksums are not in memory 
(optionally in that tool).
http://savannah.gnu.org/projects/storebackup

Dedup really helps a lot - I think more than I could imagine before I was 
engaged in this kind of backup. You will not beleve how many identical files 
are in a filesystem to give a simple example.

EMC has very big boxes for this with lots of RAM in it.
I think the first problem which has to be solved is the memory problem. 
Perhaps something asynchronous to find identical blocks and storing the 
checksums on disk?

Heinz
