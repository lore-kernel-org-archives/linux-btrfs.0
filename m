Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F120EB64DD
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Aug 2023 02:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjHJCFJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 22:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjHJCFI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2023 22:05:08 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C91F3
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Aug 2023 19:05:07 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RLqwS6nJWz1L9Jv;
        Thu, 10 Aug 2023 10:03:52 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 10:05:04 +0800
Message-ID: <479edf26-e789-3d78-bd14-f25aa5a860a0@huawei.com>
Date:   Thu, 10 Aug 2023 10:05:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH -next] btrfs: Use LIST_HEAD to initialize splice
Content-Language: en-US
To:     <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <20230809075711.1570163-1-ruanjinjie@huawei.com>
 <ZNPWvqM-VtmYKdba@twin.jikos.cz>
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <ZNPWvqM-VtmYKdba@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2023/8/10 2:11, David Sterba wrote:
> On Wed, Aug 09, 2023 at 03:57:11PM +0800, Ruan Jinjie wrote:
>> Use LIST_HEAD() to initialize splice instead of open-coding it.
> 
> Have you checked that there are no remainig conversions? I found 2 more
> in btrfs_log_changed_extents() and btrfs_wait_ordered_roots(). Please
> add them and resend, thanks.

Sorry! I'll add them and resend it.
