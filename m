Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob12.myregisteredsite.com ([209.17.115.50]:47843 "EHLO
	atl4mhob12.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab3F1Qz1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 12:55:27 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob12.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r5SGtQef021901
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 12:55:26 -0400
Message-ID: <51CDC003.3010608@chinilu.com>
Date: Fri, 28 Jun 2013 09:55:31 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: raid1 inefficient unbalanced filesystem reads
References: <kqk4sc$t5d$1@ger.gmane.org> <20130628153418.GW4288@localhost.localdomain> <20130628153910.GM14601@carfax.org.uk> <kqkdeh$3le$1@ger.gmane.org>
In-Reply-To: <kqkdeh$3le$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/28/2013 09:25 AM, Martin wrote:
> On 28/06/13 16:39, Hugo Mills wrote:
>> On Fri, Jun 28, 2013 at 11:34:18AM -0400, Josef Bacik wrote:
>>> On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
>>>> On kernel 3.8.13:
>>>>
>>>> Using two equal performance SATAII HDDs, formatted for btrfs
>>>> raid1 for both data and metadata and:
>>>>
>>>> The second disk appears to suffer about x8 the read activity of
>>>> the first disk. This causes the second disk to quickly get
>>>> maxed out whilst the first disk remains almost idle.
>>>>
>>>> Total writes to the two disks is equal.
>>>>
>>>> This is noticeable for example when running "emerge --sync" or
>>>> running compiles on Gentoo.
>>>>
>>>>
>>>> Is this a known feature/problem or worth looking/checking
>>>> further?
>>> So we balance based on pids, so if you have one process that's
>>> doing a lot of work it will tend to be stuck on one disk, which
>>> is why you are seeing that kind of imbalance.  Thanks,
>> The other scenario is if the sequence of processes executed to do
>> each compilation step happens to be an even number, then the
>> heavy-duty file-reading parts will always hit the same parity of
>> PID number. If each tool has, say, a small wrapper around it, then
>> the wrappers will all run as (say) odd PIDs, and the tools
>> themselves will run as even pids...
> Ouch! Good find...
>
> To just test with a:
>
> for a in {1..4} ; do ( dd if=/dev/zero of=$a bs=10M count=100 & ) ; done
>
> ps shows:
>
> martin    9776  9.6  0.1  18740 10904 pts/2    D    17:15   0:00 dd
> martin    9778  8.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd
> martin    9780  8.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd
> martin    9782  9.5  0.1  18740 10904 pts/2    D    17:15   0:00 dd
>
>
> More to the story from atop looks to be:
>
> One disk maxed out with x3 dd on one cpu core, the second disk
> utilised by one dd on the second CPU core...
>
>
> Looks like using a simple round-robin is pathological for an even
> number of disks, or indeed if you have a mix of disks with different
> capabilities. File access will pile up on the slowest of the disks or
> on whatever HDD coincides with the process (pid) creation multiple...
>
>
> So... an immediate work-around is to go all SSD or work in odd
> multiples of HDDs?!
>
> Rather than that: Any easy tweaks available please?
>
>
> Thanks,
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Interesting discussion.  I just put up Gkrellm here to look at this 
issue.  What I am seeing is perhaps disturbing.  I have my root file 
system as RAID 1 on two drives, /dev/sda and /dev/sdb.  I am seeing 
continual read and write activity on /dev/sdb, but nothing at all on 
/dev/sda.  I am sure it will eventually do a big write on /dev/sda to 
sync, but it appears to be essentially using one drive in normal 
routine.  All my other filesystems, /usr, /var, /opt, are RAID 1 across 
five drives.  In this case all drives are active in use ... except the 
fifth drive.  I actually observed a long flow of continual reads and 
writes very balanced across the first four drives in this set and then, 
like a big burp, a huge write on the fifth drive.  But absolutely no 
reads from the fifth drive so far. Very interesting behavior?  These are 
all SATA ncq configured drives.  The first pair are notebook drives, the 
five drive set are all seagate 2.5" enterprise level drives. - George
