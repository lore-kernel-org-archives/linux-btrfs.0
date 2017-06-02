Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48943 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751497AbdFBNyx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 09:54:53 -0400
Date: Fri, 2 Jun 2017 15:53:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Lowmem mode check check fix for mulit-device
Message-ID: <20170602135351.GK12135@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 31, 2017 at 01:56:04PM +0800, Qu Wenruo wrote:
> This patchset will fix a false alert in lowmem mode, which doesn't handle
> RAID0/5/6/10 chunk well. (the 5th patch)
> 
> Along the lowmem fix, also enhance and cleanup some chunk verification code,
> as lowmem mode and original mode are using different chunk verification.
> (the 1st~4th patch)

Patches 1-5 applied, thanks.

> Finally, cleanup the loop device setup and move it to test/common other
> than handling in each test case. (the 6th patch)

That's a good cleanup, but the implementation has to be improved. I'll
comment in the patch.
