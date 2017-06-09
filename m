Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:36071 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdFIPuN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 11:50:13 -0400
Received: by mail-yb0-f172.google.com with SMTP id o9so16600623yba.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 08:50:13 -0700 (PDT)
MIME-Version: 1.0
From: Filip Bystricky <filipbystricky@google.com>
Date: Fri, 9 Jun 2017 08:50:12 -0700
Message-ID: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
Subject: btrfs native encryption
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear btrfs maintainers,
Google is evaluating btrfs for its potential use in android, but
currently the lack of native file-based encryption unfortunately makes
it a nonstarter. According to the FAQ (specifically the answer to
"Does btrfs support encryption"), nobody is currently working on this.
How up-to-date is that answer, and are there any new plans to add
native FBE in the future?

Thanks,
Filip Bystricky
