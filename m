From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Checksum and transform layering
Date: Mon, 08 Dec 2008 19:23:16 -0500
Message-ID: <1228782196.3962.24.camel@think.oraclecorp.com>
References: <e692861c0811052234h704c938es20b562123aa4fe9b@mail.gmail.com>
	 <1225982445.15281.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1225982445.15281.15.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-11-06 at 09:40 -0500, Chris Mason wrote:
> On Thu, 2008-11-06 at 01:34 -0500, Gregory Maxwell wrote:
> > I noticed in the compression support that the checksum is over the
> > uncompressed data.
> 
> Thanks for looking things over, more eyes always helps.
> 
> > 
> > While this has the advantages that the checksum does not have to be
> > changed as transformations are changed and the system might catch
> > errors in the compression layer, this design decision will be
> > problematic if/when encryption is supported:  Plaintext checksums
> > would leak substantial amounts of information about the content of
> > files.  
> 
> We checksum the uncompressed data because it allows us to layer other
> transformations without confusing the code, and because the checksums
> are strictly tied to logical offsets in the file.  Additional metadata
> would be required to do things differently.  It's possible but I'd
> prefer not to introduce that complexity.
> 

Just FYI, the new disk format I've pushed out checksums the data on disk
instead of the uncompressed (or unencrypted) data.  There are lots of
tradeoffs here, but I think this is a much better system overall.

Thanks for your feedback, it sparked me thinking of this now, before we
tried to finalize the disk format.

-chris


