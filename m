From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: replacing failed disks in RAID-1 (kernel BUG)?
Date: Mon, 13 Jul 2009 15:35:48 +0200
Message-ID: <4A5B3834.1040003@wpkg.org>
References: <4A5B0C39.5030905@wpkg.org> <1247491413.19180.172.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247491413.19180.172.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Woodhouse wrote:
> On Mon, 2009-07-13 at 12:28 +0200, Tomasz Chmielewski wrote:
>> How do I replace failed disks in RAID-1 mode?
> 
> I don't think you can. In theory you can remove the broken one, and you
> can add a _new_ empty one -- I say 'in theory' because you seem to have
> demonstrated both of those actions failing.
> 
> But I don't believe we have yet implemented anything to let you
> _replace_ a failed disk and recreate its original contents.
> 
> I had that on my TODO list for some time after I get the basic RAID[56]
> operation working.

It would be also interesting to have a tool to monitor the state of the 
RAID (i.e. similar to what /proc/mdstat provides for md).


I also tried to compare what happens when we do writes to md-raid and to 
btrfs-raid (RAID-1 in both cases) and it looks... strange for btrfs. Or 
perhaps this is how RAID-1 works in btrfs?

I used iostat to monitor the writes on both devices.


With md RAID-1, when we do:

# dd if=/dev/zero of=/mnt/md-raid-1/testfile

and

# iostat -dk 1


We can see the write speed on both devices is more or less the same.


With btrfs RAID-1, when we do the same, I can see that writes go to one 
drive, while the second drive receives 0 kb/s writes; then it changes 
(one drive is written to, the second isn't). Only sometimes, writes 
happen concurrently to both drives, like with md RAID-1.

Is it intended?


-- 
Tomasz Chmielewski
http://wpkg.org
