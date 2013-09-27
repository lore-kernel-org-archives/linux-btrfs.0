Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:20698 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754716Ab3I0VEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 17:04:25 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: extlinux and btrfs RAID-1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130927204419.GD28147@carfax.org.uk>
Date: Fri, 27 Sep 2013 15:04:22 -0600
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-Id: <EDAE452B-D4F1-4027-9FC3-C3EF251F8430@colorremedies.com>
References: <20130927193655.GC28147@carfax.org.uk> <1487829E-FBAE-4405-93DB-94AD30EEE144@colorremedies.com> <20130927204419.GD28147@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 27, 2013, at 2:44 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, Sep 27, 2013 at 02:12:36PM -0600, Chris Murphy wrote:
>> 
>> On Sep 27, 2013, at 1:36 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> 
>>>  When I boot the machine from its disks, I'm being told that
>>> extlinux only supports single-disk btrfs. Is this still the case?
>> 
>> I'm pretty sure the answer is yes. The last time I looked not that long ago the multiple device scenario wasn't supported.
> 
>   Dammit.
> 
>   Thanks for the info. At least this means I don't have to struggle
> with the syslinux error I've been getting... Back to grub, then.

I'm seeing in changelogs that 4.0 brought btrfs support, 4.06 brought subvolume support. Nothing in changelogs for versions 5 and 6 so far inclusive. And interestingly enough, Fedora's koji only has 4.05 current for F20 and rawhide.



Chris Murphy