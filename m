Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:59295 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbaKDWTo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 17:19:44 -0500
Message-ID: <545950F8.1050505@pobox.com>
Date: Tue, 04 Nov 2014 14:19:36 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Zygo Blaxell <zblaxell@furryterror.org>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com> <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com> <20141103034337.GM17395@hungrycats.org> <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com> <20141104043130.GN17395@hungrycats.org> <BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
In-Reply-To: <BCBD4D38-1631-418A-8F3B-16497BDEB300@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2014 10:28 AM, Chris Murphy wrote:
> On Nov 3, 2014, at 9:31 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
>> Now we have two disks with equal generation numbers.  Generations 6..9
>> on sda are not the same as generations 6..9 on sdb, so if we mix the
>> two disks' metadata we get bad confusion.
>>
>> It needs to be more than a sequential number.  If one of the disks
>> disappears we need to record this fact on the surviving disks, and also
>> cope with _both_ disks claiming to be the "surviving" one.
>
> I agree this is also a problem. But the most common case is where we know that sda generation is newer (larger value) and most recently modified, and sdb has not since been modified but needs to be caught up. As far as I know the only way to do that on Btrfs right now is a full balance, it doesn't catch up just be being reconnected with a normal mount.


I would think that any time any system or fraction thereof is mounted 
with both a "degraded" and "rw", status a degraded flag should be set 
somewhere/somehow in the superblock etc.

The only way to clear this flag would be to reach a "reconciled" state. 
That state could be reached in one of several ways. Removing the missing 
mirror element would be a fast reconcile, doing a balance or scrub would 
be a slow reconcile for a filessytem where all the media are returned to 
service (e.g. the missing volume of a RAID 1 etc is returned.)

Generation numbers are pretty good, but I'd put on a rider that any 
generation number or equivelant incremented while the system is degraded 
should have a unique quanta (say a GUID) generated and stored along with 
the generation number. The mere existence of this quanta would act as 
the degraded flag.

Any check/compare/access related to the generation number would know to 
notice that the GUID is in place and do the necessary resolution. If 
successful the GUID would be discarded.

As to how this could be implemented, I'm not fully conversant on the 
internal layout.

One possibility would be to add a block reference, or, indeed replace 
the current storage for generation numbers completely with block 
reference to a block containing the generation number and the potential 
GUID. The main value of having an out-of-structure reference is that its 
content is less space constrained, and it could be shared by multiple 
usages. In the case, for instance, where the block is added (as opposed 
to replacing the generation number) only one such block would be needed 
per degraded,rw mount, and it could be attached to as many filesystem 
structures as needed.


Just as metadata under DUP is divergent after a degraded mount, a 
generation block wold be divergent, and likely in a different location 
than its peers on a subsequent restored geometry.

A gerenation block could have other nicities like the date/time and the 
devices present (or absent); such information could conceivably be used 
to intellegently disambiguate references. For instance if one degraded 
mount had sda and sdb, and second had sdb and sdc, then itd be known 
that sdb was dominant for having been present every time.
