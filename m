Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56666 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S935153AbcI3ApG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 20:45:06 -0400
Subject: Re: [PATCH] btrfs-progs: qgroup: Fix regression leads to corrupted
 qgroup status
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
References: <20160907025419.23284-1-quwenruo@cn.fujitsu.com>
 <20160929171859.GE5531@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <98881736-4b95-bae3-2f9d-93a2a1b615fd@cn.fujitsu.com>
Date: Fri, 30 Sep 2016 08:44:58 +0800
MIME-Version: 1.0
In-Reply-To: <20160929171859.GE5531@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/30/2016 01:19 AM, David Sterba wrote:
> On Wed, Sep 07, 2016 at 10:54:19AM +0800, Qu Wenruo wrote:
>> Commit 93dabf211d74daf6e3de642bdd887a90a00f7b49
>> Author: Mark Fasheh <mfasheh@suse.de>
>> Date:   Fri Jun 17 13:37:48 2016 -0700
>>
>>     btrfs-progs: check: verify qgroups above level 0
>>
>> This commit introduced a new regression which corrupts
>> read_qgroup_status, since it iterate leaf with manually specified slot,
>> not correct path->slot[0].
>>
>> This leads to wrong slot[0] and read_qgroup_status() will read out wrong
>> flags, leading to regression.
>>
>> Fix read_qgroup_status() by using eb and slot instread of wrong path
>> strucutre.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Cc: Mark Fasheh <mfasheh@suse.de>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> I'm adding this patch to devel.  Do you have a test for the regression please?
>
>
Xfstests btrfs/114 can produce it.

If you mean to add btrfs-progs test case, then I can try to create a 
minimal image to reproduce it.

Thanks,
Qu


