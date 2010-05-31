From: Paul Millar <paul.millar@desy.de>
Subject: Re: A couple of questions
Date: Mon, 31 May 2010 20:06:45 +0200
Message-ID: <201005312006.47321.paul.millar@desy.de>
References: <201005271539.55644.paul.millar@desy.de> <20100527160044.GD3835@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100527160044.GD3835@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Thursday 27 May 2010 18:00:44 Chris Mason wrote:
> I'd suggest that you look at T10 DIF and DIX, which are targeted at
> exactly this kind of thing.  We're looking at integrating dif/dix into
> btrfs at some point.

I've been keeping half-an-eye on T10's work in ensuring end-to-end integrity.  
That you guys are planning to integrate dif/dix support is certainly welcome 
news!

In my use-case (a file-server that receives a new file from a remote client),  
I believe that, to ensure end-to-end integrity,  the server software would 
have to push the client-supplied checksum into the FS when writing a new file.  
(I believe there's some T10 slides somewhere that show this use-case) -- or 
(equivalently) the server software obtains the FS checksum for the file and 
matches it against the client-supplied value.

I'm deliberately taking the simplest case when the client has chosen the same 
checksum algorithm as the FS uses.  In reality, this may not be the case, but 
we can probably cope with that.

My concern is that, if the server-software doesn't push the client-provided 
checksum then the FS checksum (plus T-10 DIF/DIX) would not provide a rigorous 
assurance that the bytes are the same.  Without this assurance, corruption 
could still occur; for example, within the server's memory.

> We haven't looked at adler32.  crc32c was chosen because it is supported
> in hardware by recent intel CPUs.

OK, fair enough :)

Cheers,

Paul.
