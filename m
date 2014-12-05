Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1905 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaLESnv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 13:43:51 -0500
Date: Fri, 5 Dec 2014 13:43:35 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
To: <kreijack@inwind.it>
CC: <dsterba@suse.cz>, Dimitri John Ledkov <xnox@debian.org>,
        cwillu <cwillu@cwillu.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Message-ID: <1417805015.4845.0@mail.thefacebook.com>
In-Reply-To: <5481F657.8090307@inwind.it>
References: <547B5724.1060507@libero.it>
	<CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
	<CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
	<CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
	<1417793566.21214.11@mail.thefacebook.com>
	<CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
	<20141205164144.GK9754@suse.cz> <5481F657.8090307@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Dec 5, 2014 at 1:15 PM, Goffredo Baroncelli 
<kreijack@inwind.it> wrote:
> On 12/05/2014 05:41 PM, David Sterba wrote:
>>  We're looking
>>  for good reasons to justify the existence of the helper, but this is
>>  still not enough IMHO. I can see the convenience to do it 
>> automatically,
>>  but this assumes no udev available which is probably rare these 
>> days.
> 
> I have the following reasons to support a mount.btrfs helper:
> 1) it is in a good point to check that everything is ok (see the 
> thread
> related LVM snapshot, due to a dev.uuid conflicts),
> 2) it is in a good point to issue a good error explanation (missing
> device....)
> 3) it may handle case like "degraded" mode, where the filesystem is 
> not
> fully functional but even as degraded have "some" functionals..

Ok, these three things are worth improving, but I'd like to take a 
slightly different direction.  Instead of recreating chunks of btrfs 
dev scan, lets extend btrfs dev scan to at the very least understand #1 
and #2.  As much as possible we want to be leveraging the data in udev 
instead of recreating that functionality.

#3 is a slightly different feature, but we can have an extended btrfs 
dev scan or show explain the state of the filesystem to you.

 From there if we really need a mount helper, it can either use a 
libbtrfs to hit the scan code or be a bash script.

Thanks for trying to smooth our or wrinkles in this area.  It's 
definitely worth working on, I just want to make sure we recreate as 
little infrastructure as possible ;)

-chris



