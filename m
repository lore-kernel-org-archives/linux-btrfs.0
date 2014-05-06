Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:53951 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaEFUNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 16:13:30 -0400
Message-ID: <53694309.2000404@libero.it>
Date: Tue, 06 May 2014 22:16:09 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Thoughts on RAID nomenclature
References: <20140505211738.GS24298@carfax.org.uk>
In-Reply-To: <20140505211738.GS24298@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/2014 11:17 PM, Hugo Mills wrote:
[...]
>    Does this all make sense? Are there any other options or features
> that we might consider for chunk allocation at this point? 

The kind of chunk (DATA, METADATA, MIXED....) and the subvolume (when /if this possibility will come)


As how write this information I suggest the following options:


-[DATA|METADATA|MIXED|SYSTEM:]NcMsPp[:<driveslist>[:/subvolume/path]]


Where <drivelist> is an expression of the disks policy allocation:


a)
	{sdX1:W1,sdX2:W2...}

        where sdX is the partition involved and W is the weight:

#1	{sda:1,sdb:1,sdc:1}   means spread all the disks
#2	{sda:1,sdb:2,sdc:3}   means linear from sda to sdc
#3	{sda:1,sdb:1,sdc:2}   means spread on sda and sdb (grouped)
                                 then (when full)  sdc

	or
b)
#1	(sda,sdb,sdc)		means spread all the disks
#2	[sda,sdb,sdc]		means linear from sda to sdc
#3	[(sda,sdb),sdc]		means spread on sda and sdb (grouped)
                                 then (when full)  sdc

	or
c)
#1	(sda,sdb,sdc)		means spread all the disks
#2	sda,sdb,sdc		means linear from sda to sdc
#3	(sda,sdb),sdc		means spread on sda and sdb (grouped)
                                 then (when full)  sdc


Some examples:

- 1c2s3b		
		Default allocation policy

- DATA:2c3s4b		
		Default allocation policy for the DATA

- METADATA:1c4s:(sda,sdb,sdc,sdd)
		Spread over all the 4 disks for metadata

- MIXED:1c4s:sda,sdc,sdb,sdd
		Linear over the 4 disks, ordered as the list for
		Data+Metadata

- DATA:1c4s:(sda,sdc),(sdb,sdd)
		spread over sda,sdc and then when these are
		filled, spread over sdb and sdc

- METADATA:1c4s:(sda,sdb,sdc,sdd):/subvolume/path
		Spread over all the 4 disks for metadata belonging the
		subvolume /subvolume/path


I think it would be interesting to explore some configuration like

- DATA:1c:(sda)
- METADATA:2c:(sdb)

if sda is bigger and sdb is faster

Some further thoughts:
- more I think about the allocation policy per subvolume and/or file basis and more I think that it would be a messy to manage





-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
