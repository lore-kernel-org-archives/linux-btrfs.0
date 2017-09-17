Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38234 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdIQXwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 19:52:35 -0400
Received: by mail-qt0-f196.google.com with SMTP id f24so4719988qte.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:52:35 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 0/2] btrfs-progs: tests/sha* copyright clarity and compliance fixes
Date: Sun, 17 Sep 2017 19:52:25 -0400
Message-Id: <20170917235227.6452-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thank you very much for fixing up the tests!  A couple of releases ago
I noticed that they were reliably passing, but I had to exclude the
tests from my uploads because the BCP 78 license is explicitely banned
from Debian.  I plan to study Debian's autopkgtest framework and then
configure the package to automatically run the tests in a VM on one of
the buildservers for every version update.

The first patch adds what I believe is a necessary header for license
compliance, and the second removes the misleading boilerplate.  Please
consult the annotated commit messages for more information.

Thank you,
Nicholas

Nicholas D Steeves (2):
  Add required IETF Trust copyright
  Remove misleading BCP 78 boilerplate

 tests/sha-private.h |  4 ++++
 tests/sha224-256.c  | 20 --------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

-- 
2.11.0

