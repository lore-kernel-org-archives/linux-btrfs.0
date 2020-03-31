Return-Path: <SRS0=zgmC=5Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F85C2D0E8
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Mar 2020 08:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAA4C20787
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Mar 2020 08:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbgCaIPc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 04:15:32 -0400
Received: from mail.halfdog.net ([37.186.9.82]:52295 "EHLO mail.halfdog.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbgCaIPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Mar 2020 04:15:31 -0400
Received: from [37.186.9.82] (helo=localhost)
        by mail.halfdog.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <me@halfdog.net>)
        id 1jJC3V-0007s2-UT
        for linux-btrfs@vger.kernel.org; Tue, 31 Mar 2020 08:15:30 +0000
From:   halfdog <me@halfdog.net>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: FIDEDUPERANGE woes may continue (or unrelated issue?)
In-reply-to: <1911-1585557446.708051@Hw65.Ct0P.Jhsr>
References: <2442-1582352330.109820@YWu4.f8ka.f33u> <31deea37-053d-1c8e-0205-549238ced5ac@gmx.com> <1560-1582396254.825041@rTOD.AYhR.XHry> <13266-1585038442.846261@8932.E3YE.qSfc> <20200325035357.GU13306@hungrycats.org> <3552-1585216388.633914@1bS6.I8MI.I0Ki> <20200326132306.GG2693@hungrycats.org> <1911-1585557446.708051@Hw65.Ct0P.Jhsr>
Comments: In-reply-to halfdog <me@halfdog.net>
   message dated "Mon, 30 Mar 2020 08:37:26 +0000."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date:   Tue, 31 Mar 2020 08:13:30 +0000
Message-ID: <3800-1585642410.029742@bHdF.V1R4.bmTu>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

halfdog writes:
> Zygo Blaxell writes:
>> ...
>> I would try a mainline kernel just to make sure Debian didn't
>> backport something they shouldn't have.
>
> OK, so let's go for that... If I got you right, you mentioned
> two scenarios, that might yield relevant information:
>
> * Try a mainline kernel prior to "reloc_root" to see if the bug
>   could already be reproduced with that one.
> * Try a new 5.5.3 or later to see if the bug still can be reproduced.
>
> Which of both would be or higher value to you for the first test?
>
> Could you please share a kernel.org link to the exact tarball
> that should be tested? If there is a specific kernel configuration
> you deem superior for tests, that would be useful too. Otherwise
> I would use one from a Debian package with a kernel version quite
> close and adapt it to the given kernel.

Yesterday I started preparing test infrastructure and to see
if my old test documentation still works with current software.
I ran a modified trinity test on a 128MB btrfs loop mount. The
test started at 12:02, at 14:30 trinity was OOM killed. As I
did not monitor the virtual machine, over the next hours without
trinity running any more also other processes were killed one
after another until at 21:13 finally also init was killed.

As I run similar tests for many days on ext4 filesystems, could
this be related to a btrfs memory leak even leaking just due
to the btrfs kernel workers? If so, when compiling a test kernel,
is there any option you recommend setting to verify/rule out/
pin-point btrfs leakage with trinity?

> ...

