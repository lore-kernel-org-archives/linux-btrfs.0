Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34489 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaAYFKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 00:10:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6vVG-0003eD-Ls
	for linux-btrfs@vger.kernel.org; Sat, 25 Jan 2014 06:09:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 06:09:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 06:09:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 05:09:35 +0000 (UTC)
Message-ID: <pan$a07a$608e1613$631e8f4f$ff0dfe6@cox.net>
References: <52E2B73E.1050903@gmail.com>
	<7uuara-hf5.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 24 Jan 2014 21:27:19 +0100 as excerpted:

> KC <conrad.francois.artus@googlemail.com> schrieb:
> 
>> I followed your advice on NOCOW for virtualbox images and torrents
>> [...]
>> 
>> As you can see, i used the recursive flag. However, I do not know
>> whether this will automatically apply to files that will be created in
>> the future in subfolders that do not yet exist.
>> 
>> Also, how can I confirm whether a file/folder has a NOCOW attribute set
>> on it?
> 
> The C attribute is also inherited by newly created directories. But keep
> in mind that, at the time applied, it only has effects on existing files
> if they are empty (read: never written to yet). Newly created files will
> inherit the attribute from its directory and then behave as expected.
> 
> You can use lsattr to confirm the C attribute was set. But again keep in
> mind: it does not reflect the file is actually nocow because of the
> above caveat.

Excellent reply (including what I snipped).  I don't actually work with 
VMs or other huge internal-write files much here, and don't otherwise 
work with extended attributes much, so would have had to lookup lsattr, 
and wasn't actually sure on the nested subdirs inheritance point myself 
tho I thought it /should/ work that way.

And your chattr/rsync routine ensures all data will be newly copied in 
AFTER the chattr on the dir, thus nicely addressing the very critical 
point about NEW DATA ONLY coverage I was most worried about communicating 
correctly. =:^)

Which is why I so enjoy mailing lists and newsgroups.  Time and again 
I've seen one person's answer simply not getting the whole job done no 
matter how mightily they struggle to do so, but because it's a public 
list/group, someone else steps in with a followup that addresses the gaps 
left by the first answer.  It nicely takes the pressure off any one 
person to have the "perfect" reply "every" time, as well as benefiting 
untold numbers of lurkers who now understand something they didn't know 
before, but may have never thought to ask themselves. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

