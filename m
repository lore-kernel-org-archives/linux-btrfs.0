Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36282 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbcFFMRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 08:17:17 -0400
Received: by mail-pf0-f176.google.com with SMTP id z187so12540247pfz.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jun 2016 05:17:16 -0700 (PDT)
MIME-Version: 1.0
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Mon, 6 Jun 2016 20:17:15 +0800
Message-ID: <CAGeO4WO080utWsqajLKUnR5X1CgA61uZB-hpryoNN-ixq_rhXw@mail.gmail.com>
Subject: What is the worst case scenario of splitting an extent-tree's node or leaf?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have questions on how BTRFS handles the scenario that a split pf
extent-tree's node/leaf  incurs another splits in the tree's
node/leaf. Is that scenario bounded? If it is, how could I calculate
the number that the split starts looping.

Regards,
Kaho Ng
