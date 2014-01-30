Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpksrv1.mitre.org ([198.49.146.77]:45927 "EHLO
	smtpksrv1.mitre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaA3XVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 18:21:30 -0500
From: "Maziarz, Jeremy M." <jmaziarz@mitre.org>
To: Chris Murphy <lists@colorremedies.com>
CC: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Stop using btrfs
Date: Thu, 30 Jan 2014 23:21:28 +0000
Message-ID: <11EE2E4D-BB65-495E-9FA5-0278466B15B8@mitre.org>
References: <CC0E5F0A-26F9-46B9-9C24-1DDD1FF72004@mitre.org>
 <20140130214333.GA18327@carfax.org.uk>
 <0808BEA2-5BED-467B-B3F4-53EBBB7CD1DC@colorremedies.com>
In-Reply-To: <0808BEA2-5BED-467B-B3F4-53EBBB7CD1DC@colorremedies.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks guys, your suggestions were exactly what I needed.

Jeremy

On Jan 30, 2014, at 4:51 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Jan 30, 2014, at 2:43 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>> On Thu, Jan 30, 2014 at 09:27:55PM +0000, Maziarz, Jeremy M. wrote:
>>> Everyone, here is a noob question: how do completely delete a btrfs filesystem (RAID10)?
>> 
>>  wipefs, on each device, is the precision approach -- it will very
>> carefully damage the magic number in the first superblock on each
>> device, which is enough to make most tools ignore the filesystem.
>> 
>>  Alternatively, the nuclear approach is simply to overwrite the
>> first megabyte or so of the filesystem with zeros, with something like:
>> 
>> dd count=1k bs=1k if=/dev/zero of=/dev/sda
> 
> Yes with the older btrfs-progs, it indicates maybe equally old linux-utils so wipefs -a might not be up to date to delete all of the super block magics. It's worth knowing especially because mkfs.ext4 resurrects the latent btrfs back to life if the wipefs -a doesn't remove all super blocks.
> 
> Also fwiw, it's possible to use wipefs -a /dev/sd[abcd] in a single command for all drives.
> 
> 
> Chris Murphy
> 

