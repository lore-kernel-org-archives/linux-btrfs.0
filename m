From: Tobias <tracer@robotech.de>
Subject: Re: Extreme slowdown
Date: Fri, 16 Dec 2011 10:09:14 +0100
Message-ID: <4EEB0ABA.5050202@robotech.de>
References: <4EEA4124.20907@robotech.de> <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com> <CAAE6i0jL=mD=HU0GtfpJPLu__7NtV6WAuGb25CAWtV6N4f33wQ@mail.gmail.com> <4EEAC5D7.80707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chester <somethingsome2000@gmail.com>,
	"Fajar A. Nugraha" <list@fajar.net>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: nspmangalore@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EEAC5D7.80707@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.12.2011 05:15, schrieb Shyam Prasad N:
> On 12/16/2011 09:14 AM, Chester wrote:
>> On Thu, Dec 15, 2011 at 8:19 PM, Fajar A. Nugraha<list@fajar.net>  
>> wrote:
>>> On Fri, Dec 16, 2011 at 1:49 AM, Tobias<tracer@robotech.de>  wrote:
>>>> Hi all!
>>>>
>>>> My BTRFS-FS ist getting really slow. Reading is ok, writing is slow 
>>>> and
>>>> deleting is horrible slow.
>>>>
>>>> There are many files and many links on the FS.
>>>>
>>>> # btrfs filesystem df /srv/storage
>>>> Data: total=3.09TB, used=3.07TB
>>> this is ... what, over 99% full?
>>> The slow down is normal, somewhat. Same thing happens on zfs, which
>>> became slower when usage is above 80-90%.
>> I don't think "total" actually means "total space available" it
>> increases as you use up more space.
Chester is right, the disk is a 8TB Array - the fs is less than half filled.

> Wouldn't it be more valuable to first collect enough info/data to 
> debug the problem, before suggesting ways to get out of this situation?
>
> AFAIK, the slowness could be due to several reasons:
> 1. Slow disk writes.
That depends on what is slow for you. Its a SATA-Disc-Array so good 
linear Read/Write and low IOPs (compared to SSDs or SAS-Discs)

> 2. Too many things to commit to the disk.
I think there should be very little data to write/commit when deleting 
files. Remember: writing is slow, but acceptable - deleting is the problem

> 3. Too many things to do to actually accomplish the writes.
I just do rm -rf xxx. What has BTRFS to do to actually delete a file or 
directory?

> Is there some sort of profiling which we can enable, which can give us 
> info about the speeds and quantities of read and write traffic on the fs?
> Aren't there btrfs statistics that we can print out, which can give us 
> these info? If not, we probably should think about adding some.

Good question - maybe a dev can say?

Tobias

