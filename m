Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631C6C2D0C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E9DF21655
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgABT5e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 14:57:34 -0500
Received: from bang.steev.me.uk ([81.2.120.65]:60467 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgABT5e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 14:57:34 -0500
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jan 2020 14:57:33 EST
Received: from [192.168.2.15]
        by smtp.steev.me.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.2)
        id 1in6Cy-009UBH-E3
        for linux-btrfs@vger.kernel.org; Thu, 02 Jan 2020 19:32:36 +0000
Subject: Re: [PATCH v2 1/3] btrfs: add readmirror type framework
To:     linux-btrfs@vger.kernel.org
References: <1577959968-19427-1-git-send-email-anand.jain@oracle.com>
 <1577959968-19427-2-git-send-email-anand.jain@oracle.com>
From:   Steven Davies <btrfs-list@steev.me.uk>
Message-ID: <4f4a1dab-fd9b-a5b6-2109-d82fc222d208@steev.me.uk>
Date:   Thu, 2 Jan 2020 19:32:44 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1577959968-19427-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 02/01/2020 10:12, Anand Jain wrote:
> As of now we use %pid method to read stripped mirrored data. So
> application's process id determines the stripe id to be read. This type
> of read IO routing typically helps in a system with many small
> independent applications tying to read random data. On the other hand
> the %pid based read IO distribution policy is inefficient if there is a
> single application trying to read large data and the overall disk
> bandwidth remains under utilized.
> 
> So this patch introduces a framework where we could add more readmirror
> policies, such as routing the IO based on device's wait-queue or manual
> when we have a read-preferred device or a policy based on the target
> storage caching.

I think the idea is good but that it would be cleaner if the tunable was 
named read_policy rather than readmirror as it's more obvious that it 
contains a policy tunable.

Do you envisage allowing more than one policy to be active for a 
filesystem? If not, what about using the same structure as the CPU 
frequency and block IO schedulers with the format

#cat /sys/block/sda/queue/scheduler
noop [deadline] cfq

Such that btrfs would (eventually) have something like

#cat /sys/fs/btrfs/UUID/read_policy
by_pid [user_defined_device] by_shortest_queue

And the policy would be changed by echo'ing the new policy name to the 
read_policy kobject.

Steve
