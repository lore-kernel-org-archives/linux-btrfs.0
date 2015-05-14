Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33836 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbbENMn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 08:43:26 -0400
MIME-Version: 1.0
Date: Thu, 14 May 2015 08:43:25 -0400
Message-ID: <CA+5PVA5HhK07LHXcPxDV=JztgdRRa+2LsK7RJXDZ-Y+esAqX1g@mail.gmail.com>
Subject: btrfs balance 4.0 regression?
From: Josh Boyer <jwboyer@fedoraproject.org>
To: osandov@osandov.com, Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Omar and Chris,

We have a bug reported [1] against 4.0 saying that btrfs balance is
broken.  The reporter found a revert patch that Omar sent [2] to
revert commit 2f0810880.  Looking in Linus' latest tree, I don't see
that revert and I don't immediately see a patch to fix the issue Omar
reported either.

Do either of you know if this is still an issue?  If not, which commit
was it fixed by?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1217191
[2] https://patchwork.kernel.org/patch/6238111/
