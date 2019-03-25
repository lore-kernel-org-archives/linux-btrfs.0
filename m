Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D67C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 171DD20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 22:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Lk9r3m37"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfCYW0h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:26:37 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:38329 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYW0h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 18:26:37 -0400
Date:   Mon, 25 Mar 2019 22:26:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1553552795;
        bh=jO3r6WLe5sDToDRsTA/J/6EZL70YrJ8ce6lXSYcIL/A=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=Lk9r3m37uB6L8vDCcK89TLJV4fVTvTncZ1/QOFQTsm78a1ptnqn/bZTDFKne7s+IE
         pnVO/+0hv+mFGH8P9b0p/5EFtRTcAxZrPNZN/CGaGvLE/z1TcXWdAYZt9CllspTrUy
         TWMDeoL54ld+7XIoeUFmLQ8pRBsDg0UEusBu28zQ=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   berodual_xyz <berodual_xyz@protonmail.com>
Reply-To: berodual_xyz <berodual_xyz@protonmail.com>
Subject: parent transid verify failed / FS wont mount / help please!
Message-ID: <F4iB3ncMhJwa1h8e21JOCzT6VJADai5sLrMwrjvDwGbC5UjWSaregJSV1dzsfTAQwRBSsDL7ky6f9uVHPFH-2g_DaKhsR9Rl23Hax5JZBeM=@protonmail.com>
Feedback-ID: I1q2L7VvFsdXESkLE1a2aLBALpN2HWsXO5F205qEARYXtg94zW3HdiV9HI52kzHEEqfcUdbqlfVMVRPA6rJltg==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear all,

on a large btrfs based filesystem (multi-device raid0 - all devices okay, n=
odatacow,nodatasum...) I experienced severe filesystem corruption, most lik=
ely due to a hard reset with inflight data.
The system cannot mount (also not with "ro,nologreplay" / "nospace_cache" e=
tc.).

Running "btrfs restore" I got a reasonable amount of data backed up, but a =
large chunk is missing.

"btrfs check" gives the following error:

##
$ btrfs check -b /dev/sdd
Opening filesystem to check...
parent transid verify failed on 1048576 wanted 60234 found 60230
parent transid verify failed on 1048576 wanted 60234 found 60230
Ignoring transid failure
parent transid verify failed on 55432763981824 wanted 60233 found 60235
parent transid verify failed on 55432763981824 wanted 60233 found 60235
Ignoring transid failure
parent transid verify failed on 55432753725440 wanted 60232 found 60235
parent transid verify failed on 55432753725440 wanted 60232 found 60235
Ignoring transid failure
parent transid verify failed on 55432764063744 wanted 60233 found 60235
parent transid verify failed on 55432764063744 wanted 60233 found 60235
Ignoring transid failure
Checking filesystem on /dev/sdd
UUID: 8b19ff46-3f42-4f51-be6b-5fc8a7d8f2cd
[1/7] checking root items
Error: could not find extent items for root 268
ERROR: failed to repair root items: No such file or directory
##

I have a complete "dump tree" zip but its a couple of GB.

Some sources on the net say to run "btrfs check --init-extent-tree" but I w=
ould like to reach out first.

btrfs progs version is 4.20.2 and kernel is 4.20.17

Thank you for any help! Much appreciated!

Marcel


Sent with ProtonMail Secure Email.

