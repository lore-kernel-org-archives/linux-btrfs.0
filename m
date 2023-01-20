Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B72C05027
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Jan 2023 23:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjATXrC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 18:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjATXrB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2023 18:47:01 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F8012855
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jan 2023 15:46:59 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUowb-1p9yW91rRB-00Qi2C; Sat, 21
 Jan 2023 00:46:41 +0100
Message-ID: <603985ab-068d-a951-7428-445d2b5fbfed@gmx.com>
Date:   Sat, 21 Jan 2023 07:46:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] btrfs: raid56: protect error_bitmap update with spinlock
To:     Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <e21c9c44b8a88d381744e83dfd3b1505cc35e4e4.1674204981.git.wqu@suse.com>
 <Y8qdtwcR5q5zxaA/@infradead.org>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <Y8qdtwcR5q5zxaA/@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:PjTwA9eKYPmasB+NgvZZIYAS2zajnlvHYmgcV3k0yjOsfVY5SMW
 CKs6im42QVKdAl1Uoor+AtPeIx38T5cjfRYscvqazyeY8yV3R48eM9fzbPj99aA6OJy6eOv
 ByExeh4W03MBqjBDNSwsfZE0Pcs30qY9H5qforF7sZFN/rQ+t4Y2v1sKrsTki19aUSbNH6Y
 FT/eMHhi9r+ITAZOSR4sA==
UI-OutboundReport: notjunk:1;M01:P0:CMQPPk7RjgU=;mtfVs+Nc5Wnpg4LYS1pm+/uoy6+
 EpxDAdWz14ZrnPeBoOCuWfpPBmR0KLr3MylvYHBewTCiklsQk3dRDV8zI9xO47y73swvpp0YM
 dhTTyKPE3IcYGd0kaRlVqWy5rI5kTED1nL2scWzFgUcCFSF5IviUkmpQUKYATYcRENpJnyDGS
 puxgaJpgLFLfF+nOdMk/uTsNCNVPC6UuD33uiFWMA5DrEiJSmscFIDlrHPr9MuaEEl11Y3L8H
 tD15RrkWZUcU4NqSNEAYW5cdTQ47XqDxIj4mokqncVp38IHhv+pTlyoHbzZvO5jJs0WeEYs2T
 BwNjjNxwa9rbbcMcHXvpaFIhEJMOlqvFarzG7XWF7lQ1eTOkGw5ivYgSUd6rTczAcVkhmhoED
 JkLw9fmVSC3ykJHJupN7rCk8MqilNFbBS5HSG5f6twYcJQ5rxfOkq6nn1v0T3mTs7fMu69V9O
 L/kZRyJ0EX0GODLTF4dn/g9MX3fLahO7xAha/PkRi4U7rjOcffshTAdyvjt+Z5FmT+Zpauxh/
 7UaMxWxZ5hmwmBve5LJ/hD7bBTZcGkCJLMsx3TfltNwqLZ2otssvmKes7ph6jwbzXkJn2QmAM
 ckEnxvCzMrm9i0y37I2hNsy9XvV9FXaJy1KSn1nYiGFdHLWhzPJ7zWhOYsc4kSoKBDPtJWGgi
 k1GcN3kKBQz8isYWC7HR6FDu951nqf78WVs5MkZMscQDlj3mRf8iExw53b9JwHOaVFt37wwkI
 I+T6ntD6VOqrp7Kmj2W02Rv+lsk/bULqv5Ge3Pn0bzICaTmUQHEIfmcBYz8ZtJU4bo6Nmq3et
 b28Nyg8+KBjCsBavNMMLI/4chjpehAmJOkmMLoux2GvSYjQ83TMq1osBs2FU8hXVUT2cVWa7D
 EzDpdVFey7lpB0YPDojND/D4uUvl14OacsOAR0eDrUpUWob7HmTvOmGMUxO5S+AWQ91VxQ+HD
 3WqumXeSUhrzavQYei3FyV6+XA8=
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2023/1/20 21:57, Christoph Hellwig wrote:
> So the reads of the bitmap only happen after all bios have completed
> and the reader side really doesn't need the lock.  Having it only
> one side looks odd, and on really weakly ordered architecture might
> lack all the barriers.  Should the reads of the bitmap also take
> the lock for completeness, or can we get away with a big fat comment?
> 
> In a way that alsmost asks for just using a set_bit loop in the
> completion handlers as that makes the ordering pretty obvious.

You're right, set_bit() loop looks more common.

Thanks,
Qu
