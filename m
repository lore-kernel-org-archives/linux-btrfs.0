Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7056 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaIKN3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 09:29:20 -0400
Message-ID: <5411A3AC.1050705@fb.com>
Date: Thu, 11 Sep 2014 09:29:16 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Samer Al-Kiswany <samera@ece.ubc.ca>, <linux-btrfs@vger.kernel.org>
Subject: Re: mkdir and fsync
References: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl>
In-Reply-To: <BAY168-DS1747B8D83FA04E0D49D89AC1CF0@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
> Btrfs seems to achieve around 100k fsycs/second, which makes me believe it
> is not touching the disk during these fsyncs.
> After looking at the code, it seems indeed that fsync adds the inode to the
> current transaction but does not sync the transaction to disk.
> 
> Is this the intended behavior for metadata fsync or is this a bug?
> Is this POSIX compliant?

Which kernel and hardware?  We had some dir fsync handling bugs in the
past which may have been related.

I just did a test here, and we're definitely doing the IO.  Christoph is
right about the requirements for fsync being sloppy.  For btrfs, we do
put directory changes into the log during an fsync, but we may end up
logging only what you fsync.

So this will get child_i:

mkdir(p/child_i)
fsync(p)

This will not:

mkdir(p/child_i)
fsync(some_other_directory_that_isn't_p)

(This is different from ext34)

-chris



