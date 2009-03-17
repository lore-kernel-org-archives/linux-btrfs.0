From: Chris Mason <chris.mason@oracle.com>
Subject: Re: metadata copied/data not copied?
Date: Mon, 16 Mar 2009 20:25:45 -0400
Message-ID: <1237249545.3814.4.camel@think.oraclecorp.com>
References: <200903161035.19446.csights@fastmail.fm>
	 <49BE7003.2050404@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: CSights <csights@fastmail.fm>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49BE7003.2050404@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-03-16 at 11:28 -0400, jim owens wrote:
> CSights wrote:
> > Hi everyone,
> > 	I'm curious what would happen in btrfs if the following commands were issued:
> > 
> > # cp file1 file2
> > # chown newuser:newgroup file2
> > 
> > Where file1 was owned by olduser:oldgroup.
> > 
> > 
> > 	If I understand copy-on-write correctly the "cp" would merely create a new 
> > pointer (or whatever it is called :( ) containing the files' metadata but the 
> > file contents would not actually be duplicated.
> 
> NO.  The concept you describe requires "deduplicate".
> 
> What you are forgetting is that "cp" is a user-space program that
> reads data and writes it to a new file.  The kernel does not see
> this as a Copy.
> 

This is true, cp makes a full copy of the file.

The btrfs utilities include a program called bcp that makes a COW copy
of a single file (or directory tree) with a btrfs specific ioctl.

-chris


