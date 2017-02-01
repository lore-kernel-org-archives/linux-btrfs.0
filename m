Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45134 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753500AbdBAW1S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 17:27:18 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZ3Ms-0000ab-Jt
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 23:27:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Wed, 1 Feb 2017 22:27:01 +0000 (UTC)
Message-ID: <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Wed, 01 Feb 2017 17:43:32 +0000 as excerpted:

> This first bug is more serious because it appears to allow a
> non-privileged user to disrupt the correct operation of receive,
> creating a form of denial-of-service of a send/receive based backup
> process. If I decided that I didn't want my pron collection (or my
> incriminating emails) appearing in the backups I could just make sure
> that I removed them from the receive snapshots while they were still
> writeable.

I'll prefix this question by noting that my own use-case doesn't use send/
receive, so while I know about it in general from following the list, 
I've no personal experience with it...

With that said, couldn't the entire problem be eliminated by properly 
setting the permissions on a directory/subvol upstream of the received 
snapshot?  If said upstream parent is only readable/enterable by root (or 
some specific user), then one would have to be root or that user in 
ordered to interfere, as nobody else could even get to the receiving 
snapshot to commit mayhem.

IOW, it should work like directory permissions have always worked.  If 
you don't have enter access to the parent, you can't read/write the 
child, thus no need for btrfs-receive specific permission-hoop-jumping.  
(And of course SELinux or similar could be used to tighten permissions 
even further, should that be justified by the use-case.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

