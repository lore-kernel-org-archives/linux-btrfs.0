From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: A little confused about what remains to make a stable release
Date: Thu, 18 Nov 2010 11:22:41 -0700
Message-ID: <f1eed9c79f5f1343569363140f0c06e7@arbitraryconstant.com>
References: <AANLkTi=q4bKVGfD-QoF68NecL4e4d5dfcvMrgv5NHtb3@mail.gmail.com>
 <20101117225901.GA5367@vlad.carfax.org.uk>
 <230760eab83b95c53c2ec6e618360a01@arbitraryconstant.com>
 <20101118093907.GE2401@selene>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101118093907.GE2401@selene>
List-ID: <linux-btrfs.vger.kernel.org>

>> Beyond that, the management capabilities at this point don't look
>> ready for long term use in a production environment. By this I
>> mean adding/removing disks,
>
>    That much is already there and working.

 Only for the basics though, yes? Disks can be added, but IIRC you can't 
 really control RAID levels for new disks. To do something like start out 
 with a RAID1 mirror and add a 4 drive RAID5 with disks of different size 
 to it, you'll have to be doing it on top of another RAID layer.

 BTRFS hopes to replace MD and LVM, but for that to happen it will 
 ultimately be necessary to be able to manage sets of disks just like you 
 can with separate MD devices, or hardware RAID, or SANs.

 I mean, there might be a few cases where you don't have quite as much 
 granularity because it gets weird when you cross layers like this, but 
 broadly speaking btrfs I think it makes sense for a volume manager to 
 know about and be able to manage sets of disks.

>    What do you think is missing? Could you create and maintain a
> wishlist page on the wiki[1], and populate it with all the things 
> that
> people need for production use?

 I'd be happy to contribute my thoughts, but isn't there already a 
 project ideas page? Actually I think much of what I've mentioned is 
 already covered under the "changing raid levels" entry.

 For sets of disks, I'd be happy to add an entry, but before I take it 
 upon myself to edit the wiki it probably makes sense to give Chris or 
 someone an opportunity to disagree that it's a good idea in the first 
 place.

 Regards,

 -Anthony
