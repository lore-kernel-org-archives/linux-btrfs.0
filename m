Return-Path: <SRS0=yk9R=3P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D47C2D0DB
	for <linux-btrfs@archiver.kernel.org>; Sun, 26 Jan 2020 15:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E27E20708
	for <linux-btrfs@archiver.kernel.org>; Sun, 26 Jan 2020 15:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Z/m7pFi6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAZPye (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 10:54:34 -0500
Received: from mail-40132.protonmail.ch ([185.70.40.132]:52123 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgAZPyd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Jan 2020 10:54:33 -0500
Date:   Sun, 26 Jan 2020 15:54:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1580054069;
        bh=inXop1fl/F/hqwEewAwMrjyo9gI6bLDR7R4wNEnL/OU=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=Z/m7pFi6S/6SFCh44y/fjbYz6keTfGbFQTZU5uNUjnWY1Vf6HVWMulABQXGM/+mcv
         tg/R/Qsolg+LRv6wpvkd2vogo6Jh+nKy6MnBJX0Uo/Wq4IFxwt1JkfyQNYpfWrkSqJ
         ozSz6KKOb/EqZ7DA1iKPv8FFZ9HlzXNQ4R66LxOs=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Raviu <raviu@protonmail.com>
Reply-To: Raviu <raviu@protonmail.com>
Subject: fstrim segmentation fault and btrfs crash on vanilla 5.4.14
Message-ID: <izW2WNyvy1dEDweBICizKnd2KDwDiDyY2EYQr4YCwk7pkuIpthx-JRn65MPBde00ND6V0_Lh8mW0kZwzDiLDv25pUYWxkskWNJnVP0kgdMA=@protonmail.com>
Feedback-ID: s2UDJFOuCQB5skd1w8rqWlDOlD5NAbNnTyErhCdMqDC7lQ_PsWqTjpdH2pOmUWgBaEipj53UTbJWo1jzNMb12A==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
I've two btrfs filesystems on the same nvme disk / and /home.
I'm running fstrim -va as cronjob daily.
Today, once fstrim run, apps writing to /home got frozen. Reviewing dmesg s=
how a bug message related to fstrim and btrfs.
Rebooting the system- actually forcibly as it couldn't umount /home - and r=
unning fstrim manualy on each filesystem; on / it worked fine, on /home I g=
ot the same error.
Here are the dmesg errors:

http://cwillu.com:8080/38.132.118.66/1

Here is the output of btrfs check --readonly with home unmounted:

http://cwillu.com:8080/38.132.118.66/2

I've run scrub whith home mounted it said, `Error summary:    no errors fou=
nd`


The fstrim kernel error is reproducible on my machine, it occurs every time=
 I run it on my home. So I can test a fix, just hope it doesn't cause data =
loss.
