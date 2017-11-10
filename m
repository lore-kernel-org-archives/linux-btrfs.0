Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51567 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754122AbdKJAMx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 19:12:53 -0500
Date: Thu, 9 Nov 2017 16:12:44 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
Message-ID: <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 09, 2017 at 05:29:25PM +0800, Anand Jain wrote:
> 
> 
> On 11/09/2017 03:53 AM, Liu Bo wrote:
> >On Tue, Nov 07, 2017 at 04:32:55PM +0800, Anand Jain wrote:
> >>
> >>
> >>On 11/02/2017 08:54 AM, Liu Bo wrote:
> >>>With raid6 profile, btrfs can end up with data corruption by the
> >>>following steps.
> >>>
> >>>Say we have a 5 disks that are set up with raid6 profile,
> >>>
> >>>1) mount this btrfs
> >>>2) one disk gets pulled out
> >>>3) write something to btrfs and sync
> >>>4) another disk gets pulled out
> >>>5) write something to btrfs and sync
> >>>6) umount this btrfs
> >>>7) bring the two disk back
> >>>8) reboot
> >>>9) mount this btrfs
> >>>
> >>>Chances are mount will fail (even with -odegraded) because of failure
> >>>on reading metadata blocks, IOW, our raid6 setup is not able to
> >>>protect two disk failures in some cases.
> >>>
> >>>So it turns out that there is a bug in raid6's recover code, that is,
> >>>
> >>>if we have one of stripes in the raid6 layout as shown here,
> >>>
> >>>| D1(*)  | D2(*)  | D3 | D4 | D5    |
> >>>-------------------------------------
> >>>| data1  | data2  | P  | Q  | data0 |
> >>
> >>
> >>>D1 and D2 are the two disks which got pulled out and brought back.
> >>>When mount reads data1 and finds out that data1 doesn't match its crc,
> >>>btrfs goes to recover data1 from other stripes, what it'll be doing is
> >>>
> >>>1) read data2, parity P, parity Q and data0
> >>>
> >>>2) as we have a valid parity P and two data stripes, it goes to
> >>>    recover in raid5 style.
> >>
> >>
> >>>(However, since disk D2 was pulled out and data2 on D2 could be stale,
> >>
> >>  data2 should end up crc error, if not then raid5 recover is as
> >>  expected OR this example is confusing to explain the context of
> >>  two data stipe missing.
> >
> >The assumption you have is not true,
> 
> >when doing reconstruction, we
> >don't verify checksum for each data stripe that is read from disk.
> 
>  Why ? what if data0 (which has InSync flag) was wrong ?
> 

(Wrinting these took me the whole afternoon, hopefully it makes
sense...)

Checksum verification happens much later, in readpage's end io, and if
data0 is wrong, then the rebuilt data couldn't match its checksum.

As Qu Wenruo also has the same question, here is my input about why
checksum is not done,

a) We may have mutliple different raid profiles within one btrfs, and
   checksum tree also resides somewhere on the disks, for
   raid1(default) and raid5, two disk failures may end up with data
   loss, it applies to raid6 as well because of the bug this patch is
   addressing.

b) If this is a metadata stripe, then it's likely that the stale
   content still matches with its checksum as metadata blocks store
   their checksum in the header part, thus checksum verification can
   not be trusted.

c) If this is a data stripe, then chances are they're belonging to
   nocow/nodatasum inodes such that no checksum could be verified.  In
   case that checksum is available, yes, finally we can verify
   checksum, but keep in mind, the whole data stripe may consist of
   several pieces of data which are from different inodes, some may
   nodatacow/nodatasum, some may not.

Given all the troubles it could lead to, I'd like to avoid it.

As a raid6 system, 2 disks failures can always be tolerated by
rebuilding data from other good copies.

Now that we have known two things, i.e.
a) data1 fails its checksum verification and
b) data2 from a out-of-sync disk might be stale,
it's straightforward to rebuild data1 from other good copies.


>  I am wary about the In_sync approach. IMO we are loosing the
>  advantage of FS being merged with volume manager - which is to
>  know exactly which active stripes were lost for quicker reconstruct.
>

Thanks for pointing this out, I'd say filesystem still has some
advantages over a vanilla volume manager while resync-ing out-of-sync
disks.

>  Lets say RAID6 is 50% full and disk1 is pulled out, and at 75%
>  full disk2 is pulled out and reaches 90% full.
> 
>  So now when all the disks are back, two disks will not have
>  In_sync flag? hope I understood this correctly.
> 
>  Now.
>  15% of the data have lost two stripes.
>  25% of the data have lost one stripe.
>  50% of the data did not loose any stripe at all.
> 
>  Now for read and reconstruct..
>  50% of the data does not need any reconstruction.

A 'Yes' for this, actually I should have avoided reading from
out-of-sync disks, but I forgot to do so. So as a side effect, if the
data read out from a out-of-sync disk matches its checksum, then it's
proven to be OK.

>  25% of the data needs RAID5 style reconstruction as they have lost only one
> stripe.
>  15% of the data needs RAID6 reconstruction since they have lost two
> stripes.
>

It depends, the stripes on the out-of-sync disks could be
a) all data stripes(as the example in this patch)
b) one data stripe and one stripe P
c) one data stripe and one stripe Q

with In_sync flag,
for a) raid6 reconstruction,
for b) raid6 reconstruction,
for c) raid5 reconstruction.

>  Does InSync design here help to work like this ?
> 
>  Now for RAID1, lets say disk1 lost first 10% of the stripes and
>  disk2 lost the last 10% of the stripes and these stripes are mutually
>  exclusive. That means there is no single stripe which has lost
>  completely.
>

True, probably we can drop patch 3 to let read happen on out-of-sync
disks and go the existing repair routine.

>  There is no code yet where I can see when the In_sync will be reset,
>  which is fine for this eg. Assume no reconstruction is done. But now
>  when both the disks are being mounted and as the In_sync will be based
>  on dev_item.generation, one of it will get In_sync to me it looks like
>  there will be 10% of stripes which will fail even though its not
>  practically true in this example.
>

Not sure if I understand this paragraph, are you talking about raid1
or raid6?

Regarding to when to reset In_sync, my naive idea is to utilize scrub
to verify checksum on all content that filesystem knows and do the
repair work, If it turns out that everything looks good, then we know
the disk is already resync, it's a good time to set In_sync.

Thanks,

-liubo
