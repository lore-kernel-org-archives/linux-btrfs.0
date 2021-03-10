Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AD2C433E6
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Mar 2021 17:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5200664FC9
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Mar 2021 17:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhCJRRI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:17:08 -0500
Received: from a4-4.smtp-out.eu-west-1.amazonses.com ([54.240.4.4]:53459 "EHLO
        a4-4.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhCJRQh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Mar 2021 12:16:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1615396525;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=V+Lp2yMrIjkws3ZrphBOASFJmFc0LvRmViRwo32mkUU=;
        b=lyKzRWC62WtspFs84SPPJLXyZir+WolyIY07y0BfBlxQw2IR2kRXJU+XiDsU8eYJ
        OM6DAMhA7096K30qrHpBjq1hde7VDz05asUoRUb+mk0qQFoxkQOv1n2dmcbU1BQQrdR
        JOnYNQthxL05c0zYhvxwu/og5hdNZWRIE9bgHwxs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1615396525;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=V+Lp2yMrIjkws3ZrphBOASFJmFc0LvRmViRwo32mkUU=;
        b=lnN7ZBDjSLO5XVPQSffgsqyeA6Dg3l/qRoXoMeheoZyM9YlvjQg0d/XglSerJcba
        2TIEIsM5aZGC4zKhS92ZzVjDiNPbVy/tZBrZexoTvVe+babGccFSj06nQjqoghcTQQ1
        Uk0EqTvBrQwei4P+qWFkemxyP9GUWoE3by207aU4=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Martin Raiber <martin@urbackup.org>
Subject: Multiple files with the same name in one directory
Message-ID: <010201781d22d3e9-78ba2d74-fc45-4455-813d-367e789d3e9b-000000@eu-west-1.amazonses.com>
Date:   Wed, 10 Mar 2021 17:15:25 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2021.03.10-54.240.4.4
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I have this in a btrfs directory. Linux kernel 5.10.16, no errors in dmesg, no scrub errors:

ls -lh
total 19G
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
-rwxr-x--- 1 root     root      783 Mar 10 14:56 disk_config.dat
...

disk_config.dat gets written to using fsync rename ( write new version to disk_config.dat.new, fsync disk_config.dat.new, then rename to disk_config.dat -- it is missing the parent directory fsync).

So far no negative consequences... (except that programs might get confused).

echo 3 > /proc/sys/vm/drop_caches doesn't help.

Regards,
Martin Raiber

