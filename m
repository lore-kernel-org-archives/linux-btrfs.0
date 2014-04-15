Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41698 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaDOOXi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:23:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wa4Gv-0001pq-2p
	for linux-btrfs@vger.kernel.org; Tue, 15 Apr 2014 16:23:37 +0200
Received: from host31-49-81-191.range31-49.btcentralplus.com ([31.49.81.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 16:23:37 +0200
Received: from linux by host31-49-81-191.range31-49.btcentralplus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 16:23:37 +0200
To: linux-btrfs@vger.kernel.org
From: Bob Williams <linux@barrowhillfarm.org.uk>
Subject: Re: Can I convert an existing directory into a subvolume?
Date: Tue, 15 Apr 2014 15:23:23 +0100
Message-ID: <lijfcr$jgn$1@ger.gmane.org>
References: <lijb4u$57s$1@ger.gmane.org> <20140415141612.GN27956@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20140415141612.GN27956@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/04/14 15:16, Hugo Mills wrote:
> On Tue, Apr 15, 2014 at 02:10:54PM +0100, Bob Williams wrote:
>> Hi,
>>
>> I'm new to btrfs, just dipping my toes in the water...
>>
>> I've got two partitions, / on /dev/sda2 and /home on /dev/sda3, both
>> formatted as btrfs in a new openSUSE 13.1 installation. I copied the
>> whole of /home (4 users) into the btrfs formatted /home partition from
>> an ext4 backup.
>>
>> I would like to create snapshots of /home/user/Documents for example,
>> but I understand these have to be subvolumes first. Googling tells me I
>> can't convert a conventional subdirectory into a subvolume, so I'm
>> guessing I'll have to create a new /home/user/Documents subvolume and
>> then copy all the contents from the subdirectory. Correct? Then delete
>> the subdirectory?
> 
>    That's one way. You can refine the "copy all the contents" step by
> using cp --reflink=always, which will make reflink (CoW) copies of the
> data, which is vastly faster than an ordinary copy, as long as you're
> not trying to take the data across a mount point.
> 
>    Another way is to make a snapshot of the subvolume containing the
> thing you want to convert, and then delete the pieces you don't want
> (possibly rearranging the contents of the new subvol in the process).
> So, assuming you have your original subvol mounted on /home, and you
> want to turn /home/bob into a subvol, it would go something like this:
> 
> # btrfs sub snap /home /home/bob-temp
> # rm -rf /home/bob-temp/hugo /home/bob-temp/fred /home/bob-temp/wilma
> # mv /home/bob-temp/bob/* /home/bob-temp/
> # rmdir /home/bob-temp/bob
> # mv /home/bob /home/bob-old
> # mv /home/bob-temp /home/bob
> 
>    Both your approach and the one above involve deleting large
> quantities of things, so be careful you don't delete too much. :)
> 
>> Can the subvolume have the same name as the subdirectory it is
>> replacing, or should it be called something like 'tempDocs', and then
>> renamed back to 'Documents' after the original has gone?
> 
>    It'll have to have a different name temporarily. Subvolumes live in
> the same namespace as the rest of the filesystem objects (like files
> and directories).
> 
>    Hugo.
> 
Many thanks for your useful and clear answer. Off to play ;-)

Bob

