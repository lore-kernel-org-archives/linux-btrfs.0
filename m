Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9734C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D9720657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfAQKmv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:42:51 -0500
Received: from wp158.webpack.hosteurope.de ([80.237.132.165]:34930 "EHLO
        wp158.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbfAQKmv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 05:42:51 -0500
Received: from ip5b41acd8.dynamic.kabel-deutschland.de ([91.65.172.216] helo=[192.168.0.31]); authenticated
        by wp158.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1gk58K-0007EE-Nr; Thu, 17 Jan 2019 11:42:48 +0100
Subject: Re: issue mounting volume
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
From:   Christian Schneider <christian@ch-sc.de>
Message-ID: <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
Date:   Thu, 17 Jan 2019 11:42:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;christian@ch-sc.de;1547721770;652e3488;
X-HE-SMSGID: 1gk58K-0007EE-Nr
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> 
> You could try this patch:
> https://patchwork.kernel.org/patch/10738583/

Do you know, which kernel is needed as base for the patch? Can I apply 
it to 4.19 or do I need more recent? If you don't know, I can just try 
it out.
> Or go btrfs-restore.

I already tried a dry run:
btrfs restore -D /dev/md42 /
This is a dry-run, no files are going to be restored
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
parent transid verify failed on 448937984 wanted 68772 found 68770
parent transid verify failed on 448937984 wanted 68772 found 68770
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
parent transid verify failed on 450281472 wanted 32623 found 30451
parent transid verify failed on 450281472 wanted 32623 found 30451
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping
We have looped trying to restore files in <filename> too many times to 
be making progress, stopping

The filenames are actually directories, but as far as I understand, 
actually no files can be restored.


> I'm more interested in the history of the fs.
> 
> Did the fs get created/modified by some older kernel?
> Especially considering you're using Gentoo, and every kernel update
> needs time consuming compile, it may be caused by some older kernel.

Yes, the filesystem is "older", though I don't really know how old, I 
would guess something between 1 and 2 years, and I update kernels every 
1-2 months. Unfortunatelly I can't give better details of creation of 
the fs.

BR, Christian
