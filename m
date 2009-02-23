From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 12:23:29 -0500
Message-ID: <yq1ocwtt6cu.fsf@sermon.lab.mkp.net>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	<3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>
	<yq1wsbht8ci.fsf@sermon.lab.mkp.net>
	<200902231648.55563.ctpm@ist.utl.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Dmitri Nikulin <dnikulin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Claudio Martins <ctpm@ist.utl.pt>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200902231648.55563.ctpm@ist.utl.pt> (Claudio Martins's message of "Mon\, 23 Feb 2009 16\:48\:55 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Claudio" == Claudio Martins <ctpm@ist.utl.pt> writes:

Claudio> What brand of SSDs are we talking about?

I tested two different products that both exhibited poor behavior during
frequent resets/power cycles.  I can't really disclose details but rest
assured I'm working with the vendors in question to get this fixed.
Just last Friday I received a couple of updated drives that appear to
work correctly.  But I haven't tested them extensively yet.


Claudio> What filesystems did you experiment with?

Some tests were done with ext3 but most tests were done using my own
integrity checking tooling and/or dt.

In the filesystem case it was trivial to map out the affected files in
debugfs and correlate those to a logical region on the disk.

-- 
Martin K. Petersen	Oracle Linux Engineering
