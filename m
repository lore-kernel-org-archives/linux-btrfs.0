Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:38992 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3KYJUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 04:20:14 -0500
Message-ID: <5293164C.2040201@hesbynett.no>
Date: Mon, 25 Nov 2013 10:20:12 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: russell@coker.com.au, stan@hardwarefreak.com
CC: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <201311241619.08668.russell@coker.com.au> <52927343.9000203@hardwarefreak.com> <201311251314.06277.russell@coker.com.au>
In-Reply-To: <201311251314.06277.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/11/13 03:14, Russell Coker wrote:
> On Mon, 25 Nov 2013, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>> If that is the problem then the solution would be to just enable
>>> read-ahead. Don't we already have that in both the OS and the disk
>>> hardware?  The hard- drive read-ahead buffer should at least cover the
>>> case where a seek completes but the desired sector isn't under the
>>> heads.
>>
>> I'm not sure if read-ahead would solve such a problem, if indeed this is
>> a possible problem.  AFAIK the RAID5/6 drivers process stripes serially,
>> not asynchronously, so I'd think the rebuild may still stall for ms at a
>> time in such a situation.
> 
> For a RAID block device (such as Linux software RAID) read-ahead should work 
> well.  For a RAID type configuration managed by the filesystem where you might 
> have different RAID levels in the same filesystem it might not be possible.
> 
> It would be a nice feature to have RAID-0 for unimportant files and RAID-1 or 
> RAID-6 for important files on the same filesystem.  But that type of thing 
> would really complicate RAID rebuild.
> 

I think btrfs is planning to have such features - different files can
have different raid types.  It certainly supports different raid levels
for metadata and file data.  But it is definitely a feature you want on
the filesystem level, rather than the raid block device level.

