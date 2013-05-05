Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38120 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3EEJWj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 05:22:39 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: george@chinilu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub CPU usage ...
Date: Sun, 05 May 2013 11:22:36 +0200
Message-ID: <2221106.SQ983GtkxQ@merkaba>
In-Reply-To: <518555FF.4020704@chinilu.com>
References: <518555FF.4020704@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi George!

Am Samstag, 4. Mai 2013, 11:39:59 schrieb George Mitchell:
> the next update.  I am using btrfs raid 1 across five 500GB Seagate 
> nearline drives and btrfs single on a Seagate 4TB backup drive.  I am 
> absolutely delighted with how this system is working.  This is my 
> primary day in and day out system.  I have to date hard crashed this 
> system at least three times without sustaining any apparent damage to 
> the filesystems.  Perhaps I have just been extremely lucky, but it seems 
> like most of the major holes have been closed at this point.  Actually I 
> have only two significant issues currently with btrfs.

Are you aware that BTRFS RAID-1 works differently than block based RAID? BTRFS 
will only be holding two copies of every data or metadata chunk on two 
different drives, regardless how many drives you use. So only one drive may 
fail.

Well, I think you will have notices with df output for the filesystem, but I 
thought I mention it, just in case.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
