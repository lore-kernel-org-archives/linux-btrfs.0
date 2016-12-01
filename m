Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30642 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753498AbcLABJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 20:09:08 -0500
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
 <20161102152151.GH12522@twin.jikos.cz>
 <cedc76f5-fadc-c6d0-b491-eb16ccc3e15a@cn.fujitsu.com>
 <20161107170523.GR12522@twin.jikos.cz>
 <bef6db9e-c106-c31b-22a5-708d2ce1221b@cn.fujitsu.com>
 <20161130163414.GS12522@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <7e15409b-7aff-dab8-a5b2-b3292d972489@cn.fujitsu.com>
Date: Thu, 1 Dec 2016 09:09:00 +0800
MIME-Version: 1.0
In-Reply-To: <20161130163414.GS12522@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/01/2016 12:34 AM, David Sterba wrote:
> On Wed, Nov 16, 2016 at 10:27:59AM +0800, Qu Wenruo wrote:
>>> Yes please. Third namespace for existing error bits is not a good
>>> option. Move the I_ERR bits to start from 32 and use them in the low-mem
>>> code that's been merged to devel.
>>
>> I didn't see such fix in devel branch.
>
> Well, that's because nobody implemented it and I was not intending to do
> it myself as it's a followup to yor lowmem patchset in devel.
>
>
OK, I'm going to fix it soon.

Thanks,
Qu


