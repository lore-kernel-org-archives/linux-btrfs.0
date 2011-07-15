From: david@lang.hm
Subject: Re: Mis-Design of Btrfs?
Date: Fri, 15 Jul 2011 10:01:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1107150954300.3745@asgard.lang.hm>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com>
 <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny> <alpine.DEB.2.02.1107150920180.3745@asgard.lang.hm>
 <4E206FF8.9090803@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, NeilBrown <neilb@suse.de>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E206FF8.9090803@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 15 Jul 2011, Ric Wheeler wrote:

> On 07/15/2011 05:23 PM, david@lang.hm wrote:
>> On Fri, 15 Jul 2011, Chris Mason wrote:
>> 
>>> Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
>>>> On 07/15/2011 12:34 PM, Chris Mason wrote:
>>> 
>>> By bubble up I mean that if you have multiple layers capable of doing
>>> retries, the lowest levels would retry first.  Basically by the time we
>>> get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
>>> do to help.
>> 
>> the problem with doing this is that it can end up stalling the box for 
>> significant amounts of time while all the retries happen.
>> 
>> we already see this happening today where a disk read failure is retried 
>> multiple times by the disk, multiple times by the raid controller, and then 
>> multiple times by Linux, resulting is multi-minute stalls when you hit a 
>> disk error in some cases.
>> 
>> having the lower layers do the retries automatically runs the risk of 
>> making this even worse.
>> 
>> This needs to be able to be throttled by some layer that can see the entire 
>> picture (either by cutting off the retries after a number, after some time, 
>> or by spacing out the retries to allow other queries to get in and let the 
>> box do useful work in the meantime)
>> 
>> David Lang
>> 
>
> That should not be an issue - we have a "fast fail" path for IO that should 
> avoid retrying just for those reasons (i.e., for multi-path or when 
> recovering a flaky drive).
>
> This is not a scheme for unbounded retries. If you have a 3 disk mirror in 
> RAID1, you would read the data no more than 2 extra times and almost never 
> more than once.  That should be *much* faster than the multiple-second long 
> timeout you see when waiting for SCSI timeout to fire, etc.

this issue is when you stack things.

what if you have a 3 piece raid 1 on top of a 4 piece raid 6?

so you have 3 raid1 retries * N raid 6 retries. depending on the order 
that you do the retries in, and how long it takes that try to fail, this 
could start to take significant amounts of time.

if you do a retry on the lower level first, the raid 6 could try several 
different ways to combine the drives to get the valid data (disks 1,2  2,3 
3,4 1,3 1,4 2,4 1,2,3 1,2,4 1,3,4 2,3,4) add more disks and it gets worse 
fast.

add more layers and you multiple the number of possible retries.

my guess is that changing to a different method at the upper level is 
going to avoid the problem area faster then doing so at a lower level 
(because there is less hardware in common with the method that just gave 
the wrong answer)

David Lang
