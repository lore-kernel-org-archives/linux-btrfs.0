Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1065CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACAF2081C
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 09:24:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CACAF2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbeK1UZ3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 15:25:29 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41677 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727382AbeK1UZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 15:25:29 -0500
X-IronPort-AV: E=Sophos;i="5.56,290,1539619200"; 
   d="scan'208";a="48783082"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 17:24:30 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 44F9E4B6ED56;
        Wed, 28 Nov 2018 17:24:27 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 17:24:32 +0800
Date:   Wed, 28 Nov 2018 17:24:24 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Nikolay Borisov <nborisov@suse.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [RFC PATCH] btrfs: drop file privileges in btrfs_clone_files
Message-ID: <20181128092424.GC3002@fnst.localdomain>
References: <20181128030731.10288-1-lufq.fnst@cn.fujitsu.com>
 <3377ecbb-a46b-bd85-10b3-7163535a4332@suse.com>
 <20181128074625.GA27028@infradead.org>
 <c47362b2-59e6-56d2-a023-1e101edc161c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c47362b2-59e6-56d2-a023-1e101edc161c@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 44F9E4B6ED56.AB983
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:48:07AM +0200, Nikolay Borisov wrote:
>
>
>On 28.11.18 г. 9:46 ч., Christoph Hellwig wrote:
>> On Wed, Nov 28, 2018 at 09:44:59AM +0200, Nikolay Borisov wrote:
>>>
>>>
>>> On 28.11.18 г. 5:07 ч., Lu Fengqi wrote:
>>>> The generic/513 tell that cloning into a file did not strip security
>>>> privileges (suid, capabilities) like a regular write would.
>>>>
>>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>> ---
>>>> The xfs and ocfs2 call generic_remap_file_range_prep to drop file
>>>> privileges, I'm not sure whether btrfs should do the same thing.
>>>
>>> Why do you think btrfs shouldn't do the same thing. Looking at

I'm not sure btrfs doesn't use generic check intentionally for some reason.

>>> remap_file_range_prep it seems that btrfs is missing a ton of checks
>>> that are useful i.e immutable files/aligned offsets etc.

It is indeed.

In addition, generic_remap_file_range_prep will invoke inode_dio_wait
filemap_write_and_wait_range for the source and destination inode/range.
For the dedupe case, it will call vfs_dedupe_file_range_compare.

I still can't judge whether these operations are welcome by btrfs. I
will go deep into the code.

>> 
>> Any chance we could move btrfs over to use remap_file_range_prep so that
>> all file systems share the exact same checks?

In theory we can call generic_remap_file_range_prep in
btrfs_remap_file_range, which give us the opportunity to clean up the
duplicate check code in btrfs_extent_same and btrfs_clone_files.

>
>I'm not very familiar with the, Filipe is more familiar so adding to CC.
>But IMO we should do that provided there are no blockers.
>
>Filipe, what do you think, is it feasible?

I'm all ears for the suggestions.

-- 
Thanks,
Lu


