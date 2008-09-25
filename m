From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hang running fs_mark
Date: Thu, 25 Sep 2008 18:28:06 -0400
Message-ID: <1222381686.7028.86.camel@think.oraclecorp.com>
References: <20080925175643.GA14205@unused.rdu.redhat.com>
	 <1222367822.7028.55.camel@think.oraclecorp.com>
	 <20080925183435.GB14205@unused.rdu.redhat.com>
	 <1222369531.7028.58.camel@think.oraclecorp.com> <48DBF693.20501@redhat.com>
	 <1222376682.7028.80.camel@think.oraclecorp.com>
	 <48DBFE4D.6080100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48DBFE4D.6080100@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-09-25 at 17:10 -0400, Ric Wheeler wrote:

> > Ok, I have that fs_mark test running here.  How far did yours get before
> > it stopped?
> >
> > -chris
> >
> >   
> I had gone (in heavy fsync mode) up to about 8 million files on a 1TB 
> s-ata disk:
> 
>     17      8064000        20480          5.6         15301404
> 
> This is the new (no system sync() call) Chris special fs_mark.  The rate 
> had been quite reasonable, starting out at around 160 20k files/sec, 
> went under 100 files/sec at around 3 million files and then fell under 
> 50 files/sec at around 7.5 million before hitting this really low speed 
> at just under 8 million.
> 
> Maybe it really was not hung, just extremely slow...
> 

I'm at 6.9 million files so far on a 500GB disk, and not surprisingly, I
get  155 files/sec ;)  My hope is that we're spinning around due to bad
accounting on the reserved extents, and that Yan's latest patch set will
fix it.

-chris



