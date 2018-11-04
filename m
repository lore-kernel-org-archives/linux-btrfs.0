Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BE0C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 14:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B33C22081D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 14:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B33C22081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dirtcellar.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbeKDXaC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 18:30:02 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:47613 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbeKDXaC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 18:30:02 -0500
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:26097 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gJJAv-0000pP-Qm; Sun, 04 Nov 2018 15:14:49 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: BTRFS did it's job nicely (thanks!)
To:     Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
 <pan$e0431$656787$a32d9060$a6ef81db@cox.net>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <6710db8e-c192-e5ae-86e3-b60b15749641@dirtcellar.net>
Date:   Sun, 4 Nov 2018 15:14:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <pan$e0431$656787$a32d9060$a6ef81db@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Duncan wrote:
> waxhead posted on Fri, 02 Nov 2018 20:54:40 +0100 as excerpted:
> 
>> Note that I tend to interpret the btrfs de st / output as if the error
>> was NOT fixed even if (seems clearly that) it was, so I think the output
>> is a bit misleading... just saying...
> 
> See the btrfs-device manpage, stats subcommand, -z|--reset option, and
> device stats section:
> 
> -z|--reset
> Print the stats and reset the values to zero afterwards.
> 
> DEVICE STATS
> The device stats keep persistent record of several error classes related
> to doing IO. The current values are printed at mount time and
> updated during filesystem lifetime or from a scrub run.
> 
> 
> So stats keeps a count of historic errors and is only reset when you
> specifically reset it, *NOT* when the error is fixed.
> 
Yes, I am perfectly aware of all that. The issue I have is that the 
manpage describes corruption errors as "A block checksum mismatched or 
corrupted metadata header was found". This does not tell me if this was 
a permanent corruption or if it was fixed. That is why I think the 
output is a bit misleadning (and I should have said that more clearly).

My point being that btrfs device stats /mnt would have been a lot easier 
to read and understand if it distinguished between permanent corruption 
e.g. unfixable errors vs fixed errors.

> (There's actually a recent patch, I believe in the current dev kernel
> 4.20/5.0, that will reset a device's stats automatically for the btrfs
> replace case when it's actually a different device afterward anyway.
> Apparently, it doesn't even do /that/ automatically yet.  Keep that in
> mind if you replace that device.)
> 
Oh thanks for the heads up, I was under the impression that the device 
stats was tracked by btrfs devid, but apparently it is (was) not. Good 
to know!
