Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0087.outbound.protection.outlook.com ([104.47.42.87]:49760
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1423134AbeBORP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 12:15:56 -0500
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Subject: Metadata / Data on Heterogeneous Media
Message-ID: <1b2df382-0402-a806-9ebf-996fabf22ba4@panasas.com>
Date: Thu, 15 Feb 2018 12:15:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In discussing the performance of various metadata operations over the 
past few days I've had this idea in the back of my head, and wanted to 
see if anybody had already thought about it before (likely, I would guess).

It appears based on this page:
https://btrfs.wiki.kernel.org/index.php/Btrfs_design
that data and metadata in BTRFS are fairly well isolated from one 
another, particularly in the case of large files.  This appears 
reinforced by a recent comment from Qu ("...btrfs strictly
split metadata and data usage...").

Yet, while there are plenty of options to RAID0/1/10/etc across 
generally homogeneous media types, there doesn't appear to be any 
functionality (at least that I can find) to segment different BTRFS 
internals to different types of devices.  E.G., place metadata trees and 
extent block groups on SSD, and data trees and extent block groups on 
HDD(s).

Is this something that has already been considered (and if so, 
implemented, which would make me extremely happy)?  Is it feasible it is 
hasn't been approached yet?  I admit my internal knowledge of BTRFS is 
fleeting, though I'm trying to work on that daily at this time, so 
forgive me if this is unapproachable for obvious architectural reasons.

Best,

ellis
