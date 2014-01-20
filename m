Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61031 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaATM1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 07:27:50 -0500
Received: by mail-ig0-f180.google.com with SMTP id m12so7796751iga.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 04:27:49 -0800 (PST)
Message-ID: <52DD148E.3060200@gmail.com>
Date: Mon, 20 Jan 2014 07:20:30 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
In-Reply-To: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-16 14:23, Toggenburger Lukas wrote:
> Hi all
> 
> I'm a student of ICT currently doing my master's degree besides working as a research assistant. Currently I'm looking for topics for my master thesis. One of my ideas was to work on Btrfs. I studied the list of project ideas at https://btrfs.wiki.kernel.org/index.php/Project_ideas and am especially interested in working on one of the following topics:
> 
> 1. (Enhanced) hot spare support as described in https://btrfs.wiki.kernel.org/index.php/Project_ideas#Hot_spare_support and https://btrfs.wiki.kernel.org/index.php/Project_ideas#.22Enhanced.22_.28ala_RAID.29_support
> 
> 2. Adding more checksumming algorithms ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#More_checksumming_algorithms )
> 
> 3. Improving subvolume handling regarding taking recursive snapshots ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots ) and taking snapshots of arbitrary directories ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories )

Another option that I would personally love to see would be support for
write-mostly devices (that is, devices in a RAID1/RAID10 setup that only
get written too unless the data can't be found elsewhere).  This would
in particular provide an alternative to using bcache/dm-cache (namely an
SSD and HDD in RAID1 with the HDD set to write-mostly).
Based on the current development focus, I don't think anybody is working
on this already (I would be, but I don't have either the time or the
skills with kernel programming that would be needed).


