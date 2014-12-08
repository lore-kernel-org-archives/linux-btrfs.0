Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:59988 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbaLHAMR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 19:12:17 -0500
Message-ID: <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
In-Reply-To: <5484DC3C.7040409@inwind.it>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it>
    <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
    <5484DC3C.7040409@inwind.it>
Date: Sun, 7 Dec 2014 16:12:16 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: kreijack@inwind.it
Cc: ashford@whisperpc.com, "Shriramana Sharma" <samjnaa@gmail.com>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo,

> So in case you have a raid1 filesystem on two disks; each disk has 300GB
> free; which is the free space that you expected: 300GB or 600GB and why ?

You should see 300GB free.  That's what you'll see with RAID-1 with a
hardware RAID controller, and with MD RAID.  Why would you expect to see
anything else with BTRFS RAID?

Peter Ashford

