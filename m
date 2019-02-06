Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EC8C282CB
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 00:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2992A2183E
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 00:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="bOYIZawc";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="pvgC+yNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfBFAgV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 19:36:21 -0500
Received: from a4-1.smtp-out.eu-west-1.amazonses.com ([54.240.4.1]:43286 "EHLO
        a4-1.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbfBFAgU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Feb 2019 19:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1549413378;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=mu0rKYkqgvsjzuqaXxlcJNiP02HasUCeytZ+VGrNH/8=;
        b=bOYIZawci/JcWdBzjj3MbOQ9ZMjJt2DHDo3otC6AppdLkUQloac0r8InjhEUfW6Z
        UDmOrkpYv93uJjaenZITUxxma3GpnYUPQg2F2db5Niq174Ukyiwx4FfOWs8+t1x5M6z
        TwFPSctKvQjjzlfH2EHbWJ1zt2jyJagetqE+ao1Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1549413378;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=mu0rKYkqgvsjzuqaXxlcJNiP02HasUCeytZ+VGrNH/8=;
        b=pvgC+yNte8uOezQZhlOpDlGWwlnD7JYkY4px346V+TMwzdBmlC7q7fQ5qSkm8saL
        zYxvL0ztQGaeLaG5ZROmDArmGsjDUHqZtP+IJjeU2hP98NY/1rh9QH9TaWktaVJ6jQD
        11T6wMwmfVa+RjpILQ5qvR+E4BqtMOffdrwPOfDY=
Subject: Re: New hang (Re: Kernel traces), sysreq+w output
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "Stephen R. van den Berg" <srb@cuci.nl>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl> <20190123155046.GA8995@cuci.nl>
 <20190125080137.GA27316@cuci.nl> <20190205221802.GA30715@cuci.nl>
 <db1081bb-d8c4-0ad4-104f-e22d5acce3b4@gmx.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <01020168c03beaab-004038b6-b18d-4b70-9803-4a9e51f73d36-000000@eu-west-1.amazonses.com>
Date:   Wed, 6 Feb 2019 00:36:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <db1081bb-d8c4-0ad4-104f-e22d5acce3b4@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2019.02.06-54.240.4.1
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 06.02.2019 01:22 Qu Wenruo wrote:
> On 2019/2/6 上午6:18, Stephen R. van den Berg wrote:
>> Are these Sysreq+w dumps not usable?
>>
> Sorry for the late reply.
>
> The hang looks pretty strange, and doesn't really look like previous
> deadlock caused by tree block locking.
> But some strange behavior about metadata dirty pages:
>
> This looks like to be the cause of the problem.
>
> kworker/u16:1   D    0 19178      2 0x80000000
> Workqueue: btrfs-endio-write btrfs_endio_write_helper
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? schedule_timeout+0xb2/0xec
>  ? __next_timer_interrupt+0xae/0xae
>  ? io_schedule_timeout+0x1b/0x3d
>  ? balance_dirty_pages+0x7a7/0x861
>  ? usleep_range+0x7e/0x7e
>  ? schedule+0x60/0x71
>  ? schedule_timeout+0x32/0xec
>  ? balance_dirty_pages_ratelimited+0x204/0x225
>  ? btrfs_finish_ordered_io+0x584/0x5ac
>  ? normal_work_helper+0xfe/0x243
>  ? process_one_work+0x18d/0x271
>  ? rescuer_thread+0x278/0x278
>  ? worker_thread+0x194/0x23f
>  ? kthread+0xeb/0xf0
>  ? kthread_associate_blkcg+0x86/0x86
>  ? ret_from_fork+0x35/0x40
>
> But I'm not familiar with balance_dirty_pages part, thus can't provide
> much details about this.
That balance_dirty_pages call was removed with the latest stable kernels
(
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/btrfs?h=linux-4.20.y&id=480c6fb23eb80e88eba7e4603304710ee7a9416f
).
