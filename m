Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53675 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdBBACa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 19:02:30 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZ4r0-0004r1-VD
        for linux-btrfs@vger.kernel.org; Thu, 02 Feb 2017 01:02:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Thu, 2 Feb 2017 00:02:16 +0000 (UTC)
Message-ID: <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
        <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
        <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Wed, 01 Feb 2017 22:51:34 +0000 as excerpted:

>> [C]ouldn't the entire problem be eliminated by properly
>> setting the permissions on a directory/subvol upstream of the received
>> snapshot?
> 
> I (honestly) don't know. But even if that does work, it is clearly only
> a workround for the bug. Where in the documentation does it warn the
> system manager about the problem? Where does it tell them that they had
> better make sure they only receive into a directory tree which does not
> allow users read or execute access (not just not write access!)? What if
> part of the point of the backup strategy is that user's have read access
> to these snapshots so they can restore their own files?
> 
> The possibility of a knowledgeable system manager being able to
> workround the problem by limiting how they use it doesn't stop it being
> a bug.

If it's a workaround, then many of the Linux procedures we as admins and 
users use every day are equally workarounds.  Setting 007 perms on a dir 
that doesn't have anything immediately security vulnerable in it, simply 
to keep other users from even potentially seeing or being able to write 
to something N layers down the subdir tree, is standard practice.

Which is my point.  This is no different than standard security practice, 
that an admin should be familiar with and using without even having to 
think about it.  Btrfs is simply making the same assumptions that 
everyone else does, that an admin knows what they are doing and sets the 
upstream permissions with that in mind.  If they don't, how is that 
btrfs' fault?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

