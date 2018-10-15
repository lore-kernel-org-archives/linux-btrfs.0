Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3F2C070C3
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 02:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF90720652
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 02:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF90720652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbeJOKWf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 06:22:35 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23567 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726273AbeJOKWf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 06:22:35 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46134721"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Oct 2018 10:39:23 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4E4174B6ED5F;
        Mon, 15 Oct 2018 10:39:21 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 15 Oct 2018 10:39:25 +0800
Date:   Mon, 15 Oct 2018 10:39:19 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Some trivail cleanup about dealyed-refs
Message-ID: <20181015023918.GF3369@fnst.localdomain>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
 <20181011115137.GN29418@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181011115137.GN29418@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 4E4174B6ED5F.AC7DC
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 01:51:37PM +0200, David Sterba wrote:
>On Thu, Oct 11, 2018 at 01:40:32PM +0800, Lu Fengqi wrote:
>> There is no functional change. Just improve readablity.
>> 
>> PATCH 1-4 parameter cleanup patches
>> PATCH 5 cleanup about btrfs_select_ref_head
>> PATCH 6 switch int to bool; add some comment
>> 
>> Lu Fengqi (6):
>>   btrfs: delayed-ref: pass delayed_refs directly to
>>     btrfs_select_ref_head()
>>   btrfs: delayed-ref: pass delayed_refs directly to
>>     btrfs_delayed_ref_lock()
>>   btrfs: remove fs_info from btrfs_check_space_for_delayed_refs
>>   btrfs: remove fs_info from btrfs_should_throttle_delayed_refs
>>   btrfs: simplify btrfs_select_ref_head and cleanup some local variables
>>   btrfs: switch return_bigger to bool in find_ref_head
>
>1-4 and 6 added to misc-next, thanks.

There is not patch 2 at the misc-next branch. So it was forgotten?

-- 
Thanks,
Lu


