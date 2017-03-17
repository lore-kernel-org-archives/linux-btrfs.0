Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:35996
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751272AbdCQW1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 18:27:46 -0400
In-Reply-To: 
From: Luca Citi <lciti@essex.ac.uk>
Subject: Re: Home storage with btrfs
To: <linux-btrfs@vger.kernel.org>
Message-ID: <5cdb9c38-db0c-2a24-5be3-6e00a92a244b@essex.ac.uk>
Date: Fri, 17 Mar 2017 22:27:35 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have had some troubles recently using btrfs with kernels >=4.8 when 
using the cfq scheduler.
Please see my post: http://www.spinics.net/lists/linux-btrfs/msg63599.html
I have no problem with kernels < 4.8 or when using the deadline 
scheduler (or none).

It is possible that the problem I see is a result of a major redesign 
that happened in March 2016.

So, contrary to most people advising to use very recent kernels, I 
suggest to try and strike a balance between a kernel that is recent 
enough to have known bugs fixed but old enough that any recently 
introduced change has been around for a while and tested.

Regards,
Luca

