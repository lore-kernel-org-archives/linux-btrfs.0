Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34923 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcHZW6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 18:58:20 -0400
Received: by mail-lf0-f41.google.com with SMTP id f93so66251201lfi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 15:58:19 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Sat, 27 Aug 2016 00:57:57 +0200
Message-ID: <CAJF-kY=8TG9hD-A6-YfX-2Y=O=mC6KJQpm8+V5A+SgDE7dQctg@mail.gmail.com>
Subject: fuzzed segv in btrfsck
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

let me draw your attention to
https://bugzilla.kernel.org/show_bug.cgi?id=154021 which is a
reproducible segv in btrfs-progs v4.7-42-g56e9586 I found while
fuzzing btrfs.

Best regards
Lukas
