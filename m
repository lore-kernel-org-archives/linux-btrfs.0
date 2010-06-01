From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: A couple of questions
Date: Tue, 01 Jun 2010 09:39:52 -0400
Message-ID: <yq1ljaykh1z.fsf@sermon.lab.mkp.net>
References: <201005271539.55644.paul.millar@desy.de>
	<20100527160044.GD3835@think> <201005312006.47321.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005312006.47321.paul.millar@desy.de> (Paul Millar's message
	of "Mon, 31 May 2010 20:06:45 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Paul" == Paul Millar <paul.millar@desy.de> writes:

Paul> My concern is that, if the server-software doesn't push the
Paul> client-provided checksum then the FS checksum (plus T-10 DIF/DIX)
Paul> would not provide a rigorous assurance that the bytes are the
Paul> same.  Without this assurance, corruption could still occur; for
Paul> example, within the server's memory.

For DIX we allow integrity metadata conversion.  Once the data is
received, the server generates appropriate IMD for the next layer.  Then
the server verifies that the original IMD matches the data buffer.  That
way there's no window of error.  But obviously the ideal case is where
the same IMD can be passed throughout the stack without conversion.

Not sure what you use for file service?  I believe NFSv4 allows for
checksums to be passed along. I have not looked at them closely yet,
though.

-- 
Martin K. Petersen	Oracle Linux Engineering
