Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sn1nam02on0076.outbound.protection.outlook.com ([104.47.36.76]:31584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031553AbeBNQAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 11:00:37 -0500
To: linux-btrfs@vger.kernel.org
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Subject: Status of FST and mount times
Message-ID: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
Date: Wed, 14 Feb 2018 11:00:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again -- back with a few more questions:

Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No 
compression.  No quotas enabled.  Many (potentially tens to hundreds) of 
subvolumes, each with tens of snapshots.  No control over size or number 
of files, but directory tree (entries per dir and general tree depth) 
can be controlled in case that's helpful).

1. I've been reading up about the space cache, and it appears there is a 
v2 of it called the free space tree that is much friendlier to large 
filesystems such as the one I am designing for.  It is listed as OK/OK 
on the wiki status page, but there is a note that btrfs progs treats it 
as read only (i.e., btrfs check repair cannot help me without a full 
space cache rebuild is my biggest concern) and the last status update on 
this I can find was circa fall 2016.  Can anybody give me an updated 
status on this feature?  From what I read, v1 and tens of TB filesystems 
will not play well together, so I'm inclined to dig into this.

2. There's another thread on-going about mount delays.  I've been 
completely blind to this specific problem until it caught my eye.  Does 
anyone have ballpark estimates for how long very large HDD-based 
filesystems will take to mount?  Yes, I know it will depend on the 
dataset.  I'm looking for O() worst-case approximations for 
enterprise-grade large drives (12/14TB), as I expect it should scale 
with multiple drives so approximating for a single drive should be good 
enough.

3. Do long mount delays relate to space_cache v1 vs v2 (I would guess 
no, unless it needed to be regenerated)?

Note that I'm not sensitive to multi-second mount delays.  I am 
sensitive to multi-minute mount delays, hence why I'm bringing this up.

FWIW: I am currently populating a machine we have with 6TB drives in it 
with real-world home dir data to see if I can replicate the mount issue.

Thanks,

ellis
