Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5803 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754340AbcJSGUJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 02:20:09 -0400
Subject: Re: [PATCH v13 00/15] Btrfs In-band De-duplication
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
 <20161017143047.GL11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <176c7dbe-debb-9c60-e182-d2d647f5da9a@cn.fujitsu.com>
Date: Wed, 19 Oct 2016 14:20:02 +0800
MIME-Version: 1.0
In-Reply-To: <20161017143047.GL11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/17/2016 10:30 PM, David Sterba wrote:
> On Thu, Sep 08, 2016 at 03:12:49PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux.git wang_dedupe_20160907
>
> Can you please publish the patchset in a branch that does not change
> name and is not based on for-next? I'm' going to do less manual merge
> tests with Chandan's patchset. A 'dedupe-latest' would work for me,
> otherwise feel free to keep the timestamped branches for your needs. The
> base branch should be chris' integration (not necessarily the latest
> one). Thanks.
>
>
Not a problem.

Since now the prepare patches are all in mainline, I can rebase them to 
either mainline non-rc release or Chris' for-linux-4.9.

Thanks,
Qu


