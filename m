Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:8999 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752785Ab3LMRZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 12:25:29 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: moving a subvol
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52AB3673.1030607@czarc.net>
Date: Fri, 13 Dec 2013 10:25:29 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <27814825-5AD6-4AA3-A286-D258D62CAB0C@colorremedies.com>
References: <52AB30D4.7050408@czarc.net> <52AB3673.1030607@czarc.net>
To: Gene Czarcinski <gczarcinski@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 13, 2013, at 9:31 AM, Gene Czarcinski <gczarcinski@gmail.com> wrote:

> On 12/13/2013 11:07 AM, Gene Czarcinski wrote:
>> I have hunted high and low for the information but, if it is out there,
>> it is well hidden.
>> 
>> What I want to do:  I want to relocate (move) a subvolume from one BTRFS
>> volume to a different BTRFS volume.
>> 
>> I have seen the writeup for incremental backup which takes a snapshot,
>> and then using btrfs-send and btrfs-receive to create a copy on a
>> different volume.  That works fine except the btrfs-receive set the new
>> copy to be readonly.
>> 
>> What I want to do is to use that new subvolume read/write.  The only way
>> I have figured out to do this is to create another snapshot on the new
>> volume which is NOT readonly.  I believe that means I need to keep both
>> of these subvolumes around.
> 
> As soon as I sent this I believe I found the answer.
> 
> I was sort of right about creating the new read-write (NOT readonly) snapshot.  After it is created simply delete the one which was created by btrfs-receive.
> 
> I also found out that if you want to rename a subvolume, siple do it with "mv" like you would for a directory or a file.
> 
> OK folks, do I have it correct?

Yes.


Chris Murphy