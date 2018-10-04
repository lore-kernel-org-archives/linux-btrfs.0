Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5BC64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 03:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC18620652
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 03:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC18620652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbeJDKRE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 06:17:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13185 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727318AbeJDKRE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 06:17:04 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EE79F1962BF2B;
        Thu,  4 Oct 2018 11:25:49 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.399.0; Thu, 4 Oct 2018
 11:25:46 +0800
Message-ID: <5BB58838.7080202@huawei.com>
Date:   Thu, 4 Oct 2018 11:25:44 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     <dsterba@suse.cz>, Omar Sandoval <osandov@osandov.com>,
        <dsterba@suse.com>, <jbacik@fb.com>, <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: list usage cleanup
References: <1537950945-5627-1-git-send-email-zhongjiang@huawei.com> <20180927184704.GA29754@vader> <20181001164831.GS3255@twin.jikos.cz>
In-Reply-To: <20181001164831.GS3255@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018/10/2 0:48, David Sterba wrote:
> On Thu, Sep 27, 2018 at 11:47:04AM -0700, Omar Sandoval wrote:
>> On Wed, Sep 26, 2018 at 04:35:45PM +0800, zhong jiang wrote:
>>> Trival cleanup, list_move_tail will implement the same function that
>>> list_del() + list_add_tail() will do. hence just replace them.
>>>
>>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>>> ---
>>>  fs/btrfs/send.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>> index 094cc144..d87f416 100644
>>> --- a/fs/btrfs/send.c
>>> +++ b/fs/btrfs/send.c
>>> @@ -2075,8 +2075,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
>>>   */
>>>  static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
>>>  {
>>> -	list_del(&nce->list);
>>> -	list_add_tail(&nce->list, &sctx->name_cache_list);
>>> +	list_move_tail(&nce->list, &sctx->name_cache_list);
>>>  }
>> At that point do we even need such a trivial helper, considering that
>> this is only called in one place?
> Fair point and trivial one-line helpers are on the cleanup todo list.
> The exception is when the actual helper implementation is obscuring the
> semantics and the helper is used in many places so it's not practical to
> add a comment everywhere. But it's not the case here.
>
> Zhong Jiang, please update the patch and resend, thanks.
Will add a comment here and resend in v2.

Thanks,
zhong jiang
> .
>


