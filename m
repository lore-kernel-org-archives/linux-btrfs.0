Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45706 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750926AbaDYDDs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 23:03:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Bug: Partition borked
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140425T043341-931@post.gmane.org>
Date: Thu, 24 Apr 2014 21:03:45 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B0B94494-9781-46B1-B1B4-F98196B97E70@colorremedies.com>
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com> <5356B1ED.8060608@gmail.com> <pan$df664$93c6c4b1$b586c2f$c5ce83c7@cox.net> <loom.20140425T035109-565@post.gmane.org> <loom.20140425T043341-931@post.gmane.org>
To: Andreas Reis <andreas.reis@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 8:43 PM, Andreas Reis <andreas.reis@gmail.com> wrote:

> Andreas Reis <andreas.reis <at> gmail.com> writes:
> 
>> Turns out that when I try to run any binary from the restored 
>> partition (via LiveCD), *every* *single* *one* fails with this 
>> remarkably expressive error. If I manually replace one with a 
>> fresh download, I get a SIGBUS crash instead.
> 
> Alright, there are corrupt text files too, after all. As well as a 
> handful or non-corrupted binaries.
> 
> Always the same type of btrfs error message though. Interestingly, 
> the false csum reported stays exactly the same: 2566472073. Also, 
> btrfs check --init-csum-tree fails with a plethora of backref 
> errors.

That command obliterates the csum tree. csums are not recomputed for already written files. Anytime you read an existing file, e.g. merely copy it, you'll get a long pile of csum errors because there's missing csums.

btrfs check itself is benign, but the options --init* and --repair have been fairly vertical fixes for specific problems and can make others worse; although that experience is largely based on older progs. I'm not sure yet how well 3.14 is repairing, and haven't looked at the changelog to see if btrfsck has been significantly updated in it.

Chris Murphy

