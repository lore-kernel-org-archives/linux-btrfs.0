Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52835 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaBHVuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 16:50:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCFnD-0002Pt-PS
	for linux-btrfs@vger.kernel.org; Sat, 08 Feb 2014 22:50:31 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 22:50:31 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 22:50:31 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sat, 08 Feb 2014 22:35:40 +0100
Message-ID: <cikisa-qf7.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <20140208114634.GH6490@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo@carfax.org.uk> schrieb:

> On Sat, Feb 08, 2014 at 05:33:10PM +0600, Roman Mamedov wrote:
>> On Fri, 07 Feb 2014 21:32:42 +0100
>> Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
>> 
>> > It should show the raw space available. Btrfs also supports compression
>> > and doesn't try to be smart about how much compressed data would fit in
>> > the free space of the drive. If one is using RAID1, it's supposed to
>> > fill up with a rate of 2:1. If one is using compression, it's supposed
>> > to fill up with a rate of maybe 1:5 for mostly text files.
>> 
>> Imagine a small business with some 30-40 employees. There is a piece of
>> paper near the door at the office so that everyone sees it when entering
>> or leaving, which says:
>> 
>> "Dear employees,
>> 
>> Please keep in mind that on the fileserver '\\DepartmentC', in the
>> directory '\PublicStorage7' the free space you see as being available
>> needs to be divided by two; On the server '\\DepartmentD', in
>> '\StorageArchive' and '\VideoFiles', multiplied by two-thirds. For more
>> details please contact the IT operations team. Further assistance will be
>> provided at the monthly training seminar.
>> 
>> Regards,
>> John S, CTO.'
> 
>    In my experience, nobody who uses a shared filesystem *ever* looks
> at the amount of free space on it, until it fills up, at which point
> they may look at the free space and see "0". Or most likely, they'll
> be alerted to the issue by an email from the systems people saying,
> "please will everyone delete unnecessary files from the shared drive,
> because it's full up."

Exactly that is the point from my practical experience. Only sysadmins watch 
these numbers, and they'd know how to handle them.

Imagine the future: Btrfs supports different RAID levels per subvolume. We 
need to figure out where to place a new subvolume. I need raw numbers for 
it. Df won't tell me that now. Things become very difficult now.

Free space is a number unimportant to end users. They won't look at it. They 
start to cry and call helpdesk if an application says: Disk is full. You 
cannot even save your unsaved document, because: Disk full.

The only way to solve this, is to apply quotas to users and let the 
sysadmins do the space usage planning. That will work.

I still think, there should be an extra utility which guesses the predicted 
usable free space - or an option added to df to show that.

Roman's argument is only one view of the problem. My argument (sysadmin 
space planning) is exactly the opposite view. In the future, free space 
prediction will only become more complicated, involves more code, introduces 
bugs... It should be done in user space. Df should receive raw numbers.

Storage space is cheap these days. You should just throw another disk at the 
array if free space falls below a certain threshold. End users do not care 
for free space. They just cry when it's full - no matter how accurate the 
numbers had been before. They will certainly not cry if they copied 2 MB to 
the disk but 4 MB had been taken. In a shared storage space this is probably 
always the case anyway, because just the very same moment someone else also 
copied 2 MB to the volume. So what?

>    Having a more accurate estimate of the free space is a laudable
> aim, and in principle I agree with attempts to do it, but I think the
> argument above isn't exactly a strong one in practice.

I do not disagree, too. But I think it should go to a separate utility or 
there should be a new API call in the kernel to get predicted usable free 
space based on current usage pattern. Df is meant as a utility to get 
accurate numbers. It should not tell you guessed numbers.

Whatever you design a df calculater in btrfs, it could always be too 
pessimistic or too optimistic (and could even switch unpredictably between 
both situations). So whatever you do: It is always inaccurate. It will never 
be able to exactly tell you the numbers you need. If disk space is low: Add 
disks. Clean up. Whatever. Just simply do not try to fill up your FS to just 
1kb left. Btrfs doesn't like that anyway. So: Use quotas.

Picking up the piece of paper example: You still have to tell your employees 
that the free space numbers aren't exact anyways, so their best chance is to 
simply not look at them and are better off with just trying to copy 
something.

Besides: If you want to fix this, what about the early-ENOSPC problem which 
is there by design (allocation in chunks)? You'd need to fix that, too.

-- 
Replies to list only preferred.

