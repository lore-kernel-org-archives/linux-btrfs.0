Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdKIQY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 11:24:58 -0500
Date: Thu, 9 Nov 2017 17:23:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/4] fix alert and add testcase lowmem check
Message-ID: <20171109162304.GM27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171103082806.22448-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 03, 2017 at 04:28:02PM +0800, Lu Fengqi wrote:
> Patch 1 add a test case for commit 4c75ae7a4e20 ("btrfs-progs: test: Add
> test image for lowmem mode file extent interrupt")
> Patch 2 output more detailed information about file extent interrupt
> Patch 3 fix a false alert for lowmem check
> Patch 4 add a test case for Patch 3
> 
> Lu Fengqi (4):
>   btrfs-progs: test: Add test image for lowmem mode file extent
>     interrupt

I don't understand what 'interrupt' means in this context, it's been
introduced in d88da10ddd4296cf2dd9 and I did not notice it at the time.
The error message is unclear.
