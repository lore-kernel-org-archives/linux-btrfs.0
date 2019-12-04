Return-Path: <SRS0=ure3=Z2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D018DC43603
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Dec 2019 11:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99912206DB
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Dec 2019 11:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mkaito.net header.i=@mkaito.net header.b="pFsHXgp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLDLOK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 06:14:10 -0500
Received: from adalind.mkaito.net ([147.75.80.235]:55992 "EHLO
        adalind.mkaito.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDLOK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Dec 2019 06:14:10 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 06:14:09 EST
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mkaito.net; s=mail;
        t=1575457456; bh=v72Nhso+ipOWp7D+/irr588/0y/eEy0xV104meGIcVc=;
        h=Date:To:Subject:From;
        b=pFsHXgp1kozBG7UOxtuAVuF/5IsLi2XsgDzdFPJw5jsiax6F9stS0ZJiqsVLfHQAS
         IdHr9Tmugx7ZUkuP9bHhsxajudWhkadUIe4BUeUsJUSCjgC39DaQAbrteZzAwPntwr
         r9c36klKyz+oPxYxuHfKXGk9oXPXXv6AWamBWsIU=
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 04 Dec 2019 11:04:15 +0000
To:     <linux-btrfs@vger.kernel.org>
Subject: False alert: read time tree block corruption
From:   =?utf-8?q?Christian_H=C3=B6ppner?= <chris@mkaito.net>
Message-Id: <BYWL23M0PMTD.134Q4QBKEGA96@cryptbreaker>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I'm writing because the kernel wiki page relating to this error[1] says to
write here first.

I'm (was) running Arch Linux, kernel 5.4.1, btrfs-progs 5.3.1

Yesterday during usage, the root file system remounted read-only. I was
dumb enough to react by rebooting the machine, when I was greeted by the
following error:

[  25.634530] BTRFS critical (device nvme0n1p2): corrupf leaf: block=3D8101=
45234944...
[  25.634793] BTRFS error (device nvme0n1p2): block=3D810145234944 read tim=
e tree block corruption detected
[  25.634961] BTRFS error (device nvme0n1p2): in __btrfs_free_extent:3080: =
errno=3D-5 IO failure
[  25.635042] BTRFS error (device nvme0n1p2): in btrfs_run_delayed_refs:218=
8: errno=3D-5 IO failure
[  34.653440] systemd-journald[483]: Failed to torate /var/log/journal/8f70=
37b10bbd4f25aadd3d19105ef920/system.journal

After booting to live media, I checked SMART, badblocks, `btrfs check
--readonly` and `btrfs scrub`. All came back clean. I conclude that this
is a false positive, and have downgraded the kernel to 5.3.13 as a
workaround.

How can I provide more information to help?

[1]: https://btrfs.wiki.kernel.org/index.php/Tree-checker#How_to_handle_suc=
h_error
