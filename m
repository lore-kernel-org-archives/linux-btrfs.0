Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc1s25.hotmail.com ([65.54.190.36]:53486 "EHLO
	BAY004-OMC1S25.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbaINVFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Sep 2014 17:05:31 -0400
Message-ID: <BAY168-DS278FBACE27850B5FD3BDEEC1CB0@phx.gbl>
From: Samer Al-Kiswany <samera@ece.ubc.ca>
To: "'Chris Mason'" <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>
References: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl> <5411A3AC.1050705@fb.com>
In-Reply-To: <5411A3AC.1050705@fb.com>
Subject: RE: mkdir and fsync
Date: Sun, 14 Sep 2014 13:56:38 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Chris,

We use kernel 3.2 in a virtual machine using VirtualBox. We will test it
with the latest kernel version and let you know if we face the same issue.

Thank you
-samer
http://www.ece.ubc.ca/~samera/ 
http://www.cs.wisc.edu/~samera/ 


-----Original Message-----
From: Chris Mason [mailto:clm@fb.com] 
Sent: Thursday, September 11, 2014 6:29 AM
To: Samer Al-Kiswany; linux-btrfs@vger.kernel.org
Subject: Re: mkdir and fsync

On 09/10/2014 04:55 PM, Samer Al-Kiswany wrote:
> Hi,
> 
> Thank you for help.
> 
> I am seeing a strange behavior when fsync()ing a directory.
> 
> Here is what I do
> 
> for (i=0; i < 100,000, i++){
> 	.
>       mkdir(p/child_i)
>       fsync(p)
> }
> 
> Btrfs seems to achieve around 100k fsycs/second, which makes me 
> believe it is not touching the disk during these fsyncs.
> After looking at the code, it seems indeed that fsync adds the inode 
> to the current transaction but does not sync the transaction to disk.
> 
> Is this the intended behavior for metadata fsync or is this a bug?
> Is this POSIX compliant?

Which kernel and hardware?  We had some dir fsync handling bugs in the past
which may have been related.

I just did a test here, and we're definitely doing the IO.  Christoph is
right about the requirements for fsync being sloppy.  For btrfs, we do put
directory changes into the log during an fsync, but we may end up logging
only what you fsync.

So this will get child_i:

mkdir(p/child_i)
fsync(p)

This will not:

mkdir(p/child_i)
fsync(some_other_directory_that_isn't_p)

(This is different from ext34)

-chris




