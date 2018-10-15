Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C95C070C3
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 02:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0097620659
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 02:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0097620659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbeJOKPr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 06:15:47 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:53268 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726098AbeJOKPq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 06:15:46 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46134292"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 15 Oct 2018 10:32:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 67C6A4B6ED5F;
        Mon, 15 Oct 2018 10:32:33 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 15 Oct 2018 10:32:37 +0800
Date:   Mon, 15 Oct 2018 10:32:30 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: simplify btrfs_select_ref_head and cleanup
 some local variables
Message-ID: <20181015023230.GE3369@fnst.localdomain>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
 <20181011054038.5428-6-lufq.fnst@cn.fujitsu.com>
 <e5bb27d0-fea5-30c6-afd4-aea2eae1871e@suse.com>
 <20181011121558.GF5899@fnst.localdomain>
 <0b78a3dc-bf22-fb99-afce-96b74d936173@suse.com>
 <20181011124504.GQ29418@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181011124504.GQ29418@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 67C6A4B6ED5F.AF439
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 02:45:04PM +0200, David Sterba wrote:
>On Thu, Oct 11, 2018 at 03:28:15PM +0300, Nikolay Borisov wrote:
>> > I noticed that there is a macro called SCRAMBLE_DELAYED_REFS in the
>> > extent-tree.c. I am a bit curious whether it has been forgotten by
>> > everyone, I have not found any test results about its performance impact.
>> 
>> I guess it was used during testing but nothing currently sets it. I.e it
>> might make sense to enable it if BTRFS_DEBUG is set.
>
>Agreed, the way the scrambling is supposed to be used does not align
>very well with the typical testing workflow so adding to ti the
>BTRFS_DEBUG set is ok, unless there are severe performance problems.

I will add it to the BTRFS_DEBUG set, and test if it has severe
performance problems.

>
>The part in btrfs_run_delayed_refs would be better hidden in a function
>similar to btrfs_debug_check_extent_io_range or btrfs_leak_debug_check.

Got it.

-- 
Thanks,
Lu


