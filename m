Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59725 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaCIRgm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 13:36:42 -0400
Received: by mail-qc0-f169.google.com with SMTP id i17so6822346qcy.28
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 10:36:41 -0700 (PDT)
Message-ID: <531CA6A6.4040701@gmail.com>
Date: Sun, 09 Mar 2014 13:36:38 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
CC: impactoria@googlemail.com
Subject: Re: Massive BTRFS performance degradation
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys>
In-Reply-To: <1553599.dDs6U900Vh@tethys>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2014 04:17 AM, Swâmi Petaramesh wrote:
> Le dimanche 9 mars 2014 08:48:20 KC a écrit :
>> I am experiencing massive performance degradation on my BTRFS
>> root partition on SSD.
> 
> BTW, is BTRFS still a SSD-killer ? It had this reputation a while
> ago, and I'm not sure if this still is the case, but I don't dare
> (yet) converting to BTRFS one of my laptops that has a SSD...
> 
Actually, because of the COW nature of BTRFS, it should be better for
SSD's than stuff like ext4 (which DOES kill SSD's when journaling is
enabled because it ends up doing thousands of read-modify-write cycles
to the same 128k of the disk under just generic usage).  Just make
sure that you use the 'ssd' and 'discard' mount options.
