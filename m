Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbeHWJO2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 05:14:28 -0400
Subject: Re: [PATCH 0/2] address lock contention of btree root
To: bo.liu@linux.alibaba.com, Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
 <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
 <20180821181521.nj4cxyjqt5fo5vng@US-160370MP2.local>
 <0F30A584-4FCA-4B60-B2C1-7CB51E091C9E@fb.com>
 <20180822213856.ijvr5dvi4d5qfmds@US-160370MP2.local>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d78597bd-cb6e-8dae-31cb-134194dd4960@suse.com>
Date: Thu, 23 Aug 2018 08:46:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180822213856.ijvr5dvi4d5qfmds@US-160370MP2.local>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.08.2018 00:38, Liu Bo wrote:
> hmm, looks like the current mutex with adaptive spinning doesn't offer
> read/write version, meaning we're not able to simple drop rwlock.


What about rw_semaphores?
