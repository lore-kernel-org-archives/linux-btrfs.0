Return-Path: <SRS0=FxXp=TT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=DATE_IN_PAST_06_12,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3F0C04AB4
	for <linux-btrfs@archiver.kernel.org>; Sun, 19 May 2019 17:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC1520578
	for <linux-btrfs@archiver.kernel.org>; Sun, 19 May 2019 17:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="jq1vyBPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfESRgn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 19 May 2019 13:36:43 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:63685 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfESRgn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 May 2019 13:36:43 -0400
Date:   Sun, 19 May 2019 08:11:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1558253469;
        bh=nGFhvp/USjSBl0QXuPMmV+94OB3bhxSem5PklLYlfoA=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=jq1vyBPfmC8XpghuLUceCXjdL9clA1Nsf+JkEeqzIgrlXhwU9eucS+uoNntOPQfGG
         zMhrhqUdJZ6NhsPM8qpuky6YflAv7JmDk2hV1//rrmRrh/1mGYJKyVbgJ13OhGj12S
         Hv5hYI7ySDJcrRvXJZSnvcWcrPIt26tihdIofRvU=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Newbugreport <newbugreport@protonmail.com>
Reply-To: Newbugreport <newbugreport@protonmail.com>
Subject: Btrfs send bloat
Message-ID: <clzY4RoSOURzgBtua3TjQ4WXJzgY3EwTyiaYwt49zFAPIi_jO2nAQ8O2saTwpqHH9x0ISw9AVbWOvVR4hFDIx8_dzlWKAzHwcOtEuwaXzJ8=@protonmail.com>
Feedback-ID: d6Wm0FJd7i1jFe-FGWugBSsNs-8bq-rQNjTlE-phxxZwlQCWXnoyvi9qcr4gYuV_Fena2XhvJGc4qqroBLRNtw==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I have 3-4 years worth of snapshots I use for backup purposes. I keep R-O l=
ive snapshots, two local backups, and AWS Glacier Deep Freeze. I use both s=
end | receive and send > file. This works well but I get massive deltas whe=
n files are moved around in a GUI via samba. Reorganize a bunch of files an=
d the next snapshot is 50 or 100 GB. Perhaps mv or cp with reflink=3Dalways=
 would fix the problem but it's just not usable enough for my family.

I'd like a solution to the massive delta problem. Perhaps someone already h=
as a solution, that would be great. If not, I need advice on a few ideas.

It seems a realistic solution to deduplicate the subvolume  before each sna=
pshot is taken, and in theory I could write a small program to do that. How=
ever I don't know if that would work. Will Btrfs will let me deduplicate be=
tween a file on the live subvolume and a file on the R-O snapshot (really t=
he same file but different path). If so, will Btrfs send with -p result in =
a small delta?

Failing that I could probably make changes to the send data stream, but tha=
t's suboptimal for the live volume and any backup volumes where data has be=
en received.

Also, is it possible to access the Btrfs hash values for files so I don't h=
ave to recalculate file hashes for the whole volume myself?

Thanks in advance for any advice.
