Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7628EC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 01:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A3032086A
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 01:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A3032086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbeKOL1t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 06:27:49 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2060 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725895AbeKOL1t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 06:27:49 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="48142371"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Nov 2018 09:22:04 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 078794B6EC92;
        Thu, 15 Nov 2018 09:22:00 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 15 Nov 2018 09:22:06 +0800
Date:   Thu, 15 Nov 2018 09:21:57 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix suspicious RCU usage warning in
 device_list_add
Message-ID: <20181115012157.GB1835@fnst.localdomain>
References: <20181114072456.4746-1-lufq.fnst@cn.fujitsu.com>
 <20181114160547.GH24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181114160547.GH24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 078794B6EC92.AB112
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 05:05:48PM +0100, David Sterba wrote:
>On Wed, Nov 14, 2018 at 03:24:56PM +0800, Lu Fengqi wrote:
>> =============================
>> WARNING: suspicious RCU usage
>> 4.20.0-rc2+ #23 Tainted: G           O
>> -----------------------------
>> fs/btrfs/volumes.c:886 suspicious rcu_dereference_check() usage!
>> 
>> Use btrfs_info_in_rcu instead of pr_info for the required lock/unlock of
>> RCU string.
>> 
>> Fixes: 1f265fc6f58b ("btrfs: harden agaist duplicate fsid on scanned devices")
>
>Thanks for the fix.
>
>Please note that the patch is still in the devel queue (misc-next) so
>the commit id is unstable, and such fixups get folded to the patch.
>
>You may also reply to the original mail with patch, but sending a bare
>code change without a full changelog is also fine if the original patch
>was sent long time ago and the fixup could get lost.

Got it.

-- 
Thanks,
Lu

>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/volumes.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 2186300bab91..6039ae5c549e 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -873,15 +873,15 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>>  			if (device->bdev != path_bdev) {
>>  				bdput(path_bdev);
>>  				mutex_unlock(&fs_devices->device_list_mutex);
>> -				pr_warn(
>> -		"BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
>> +				btrfs_warn_in_rcu(device->fs_info,
>> +			"duplicate device fsid:devid for %pU:%llu old:%s new:%s\n",
>
>The trailing newline is appended by all btrfs_* message helpers, removed
>in the commit.
>
>


