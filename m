Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63557 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbbAWB4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 20:56:40 -0500
Message-ID: <54C1AA53.2060207@cn.fujitsu.com>
Date: Fri, 23 Jan 2015 09:56:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <clm@fb.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>, <miaoxie@huawei.com>
Subject: Re: [PATCH] btrfs: fix raid56 scrub failed in xfstests btrfs/072
References: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com> <20150116110028.GO3685@twin.jikos.cz>
In-Reply-To: <20150116110028.GO3685@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: fix raid56 scrub failed in xfstests btrfs/072
From: David Sterba <dsterba@suse.cz>
To: <clm@fb.com>
Date: 2015年01月16日 19:00
> On Fri, Jan 09, 2015 at 09:39:40AM +0800, Gui Hecheng wrote:
>> The xfstests btrfs/072 reports uncorrectable read errors in dmesg,
>> because scrub forgets to use commit_root for parity scrub routine
>> and scrub attempts to scrub those extents items whose contents are
>> not fully on disk.
>>
>> To fix it, we just add the @search_commit_root flag back.
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Chris, please add this patch to 3.19-rc queue, followup to the new
> raid56 scrub code.
Hi Chris,

This patch doesn't seems to be included in 3.19-rc5, would you please 
add it to next rc?

Thanks,
Qu
