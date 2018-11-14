Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD83C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 03:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC16C2145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 03:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC16C2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbeKNNtJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 08:49:09 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47080 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727770AbeKNNtI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 08:49:08 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="48058281"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Nov 2018 11:47:45 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0324D4B6ED4F;
        Wed, 14 Nov 2018 11:47:42 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 14 Nov 2018 11:47:47 +0800
Date:   Wed, 14 Nov 2018 11:47:39 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v15.1 00/13] Btrfs In-band De-duplication
Message-ID: <20181114034739.GA1835@fnst.localdomain>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
 <20181113134545.GY24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181113134545.GY24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 0324D4B6ED4F.AAB30
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 02:45:45PM +0100, David Sterba wrote:
>On Tue, Nov 06, 2018 at 02:41:09PM +0800, Lu Fengqi wrote:
>> This patchset can be fetched from github:
>> https://github.com/littleroad/linux.git dedupe_latest
>> 
>> Now the new base is v4.20-rc1.
>
>Before anybody spends more time with this patchset: this is a big
>feature and quite intrusive to several btrfs subsystems. Currently it's
>on hold as it requires finishing the design phase, it's still only the
>in-memory backend and before we claim in-band dedupe, the persistent
>hash tree needs to be at least drafted or prototyped.

Thanks for your explanation. However, I'm not sure why we need to draft
a prototype of the persistent hash tree first when we are talking about
the memory backend.

-- 
Thanks,
Lu

>
>At this point there are several features that are in a more complete
>state so they get preferred when it comes to merging. I would have to
>look up what was agreed long time ago as merging plan, but at this point
>this series would require a lot of work.
>
>


