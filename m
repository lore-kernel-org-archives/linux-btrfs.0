From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Single disk performance
Date: Mon, 29 Jun 2009 08:41:49 -0400
Message-ID: <20090629124149.GF3951@think>
References: <4A44DB23.5000400@austin.ibm.com> <20090626205659.GD3951@think> <4A458373.4010603@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A458373.4010603@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 26, 2009 at 09:26:59PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
>> On Fri, Jun 26, 2009 at 09:28:51AM -0500, Steven Pratt wrote:
>>   
>>> Upgraded the btrfs tree to 6-17 and all of the stability problems 
>>> went  away on the single disk system, so not sure if this was a code 
>>> problem  or hardware, but at least stable now.
>>> Performance results updated at:
>>> http://btrfs.boxacle.net/repository/single-disk/History/History.html
>>>
>>> The fixed to the cow path are obvious for random write, although even 
>>> on  single disk the CPU overhead is very noticeable as the efficiency 
>>> graphs  show.
>>>
>>> The good news is that now the only workload that Btrfs is not at or 
>>> near  the top in performance for single disk is MailServer.
>>>     
>>
>> Thanks Steve, glad to hear the stability problems are gone.
>>
>>   
> Well, maybe I spoke too soon. :-(    Run with this patch died in similar  
> way to before.  My remote service console is not responding, so will  
> probably be Monday before I can get to the lab to restart manually.
>
>
> I am getting messages like:
>
> Lots of these timeout messages, then eventually
>
> 18:40:32 btrfs2 kernel: [ 4459.870613] sd 0:0:1:0: [sdb] Unhandled error 
> code
> Jun 26 18:40:32 btrfs2 kernel: [ 4459.870640] sd 0:0:1:0: [sdb] Result:  
> hostbyte=DID_ABORT driverbyte=DRIVER_OK
> Jun 26 18:40:32 btrfs2 kernel: [ 4459.870646] end_request: I/O error,  
> dev sdb, sector 103359232
>
> So still not sure if this is HW, but no other FS has triggered it.
>

I'm afraid Btrfs can't do this on its own.  It needs to HW, scsi
drivers or HW or scsi drivdes ;)

You could try dd if=/dev/sdb of=/dev/zero bs=512 count=1 skip=103359232

Hopefully that will fall over without btrfs helping.

-chris
