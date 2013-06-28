Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56189 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3F1Rpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 13:45:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uscju-0001Tn-9x
	for linux-btrfs@vger.kernel.org; Fri, 28 Jun 2013 19:45:42 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 19:45:42 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 19:45:42 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: raid1 inefficient unbalanced filesystem reads
Date: Fri, 28 Jun 2013 18:45:31 +0100
Message-ID: <kqki3l$nmr$1@ger.gmane.org>
References: <kqk4sc$t5d$1@ger.gmane.org> <20130628153418.GW4288@localhost.localdomain> <20130628153910.GM14601@carfax.org.uk> <kqkdeh$3le$1@ger.gmane.org> <51CDC003.3010608@chinilu.com> <20130628170410.GX4288@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130628170410.GX4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/06/13 18:04, Josef Bacik wrote:
> On Fri, Jun 28, 2013 at 09:55:31AM -0700, George Mitchell wrote:
>> On 06/28/2013 09:25 AM, Martin wrote:
>>> On 28/06/13 16:39, Hugo Mills wrote:
>>>> On Fri, Jun 28, 2013 at 11:34:18AM -0400, Josef Bacik wrote:
>>>>> On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
>>>>>> On kernel 3.8.13:

>> flow of continual reads and writes very balanced across the first four
>> drives in this set and then, like a big burp, a huge write on the fifth
>> drive.  But absolutely no reads from the fifth drive so far. Very

> Well that is interesting, writes should be relatively balanced across all
> drives.  Granted we try and coalesce all writes to one drive, flush those out,
> and go on to the next drive, but you shouldn't be seeing the kind of activity
> you are currently seeing.  I will take a look at it next week and see whats
> going on.
> 
> As for reads we could definitely be much smarter, I would like to do something
> like this (I'm spelling it out in case somebody wants to do it before I get to
> it)
> 
> 1) Keep a per-device counter of how many read requests have been done.
> 2) Make the PID based decision, and then check and see if the device we've
> chosen has many more read requests than the other device.  If so choose the
> other device.
>  -> EXCEPTION: if we are doing a big sequential read we want to stay on one disk
>     since the head will be already in place on the disk we've been pegging, so
>     ignore the logic for this.  This means saving the last sector we read from
>     and comparing it to the next sector we are going to read from, MD does this.
>     -> EXCEPTION to the EXCEPTION: if the devices are SSD's then don't bother
>        doing this work, always maintain evenness amongst the devices.
> 
> If somebody were going to do this, they'd just have to find the places where we
> call find_live_mirror in volumes.c and adjust their logic to just hand
> find_live_mirror the entire map and then go through the devices and make their
> decision.  You'd still need to keep the device replace logic.  Thanks,


Mmmm... I'm not sure trying to balance historical read/write counts is
the way to go... What happens for the use case of an SSD paired up with
a HDD? (For example an SSD and a similarly sized Raptor or enterprise
SCSI?...) Or even just JBODs of a mishmash of different speeds?

Rather than trying to balance io counts, can a realtime utilisation
check be made and go for the least busy?

That can be biased secondly to balance IO counts if some
'non-performance' flag/option is set/wanted by the user. Otherwise, go
firstly for what is recognised to be the fastest or least busy?...


Good find and good note!

And thanks greatly for so quickly picking this up.

Thanks,
Martin

