Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:34640 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdFISJb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 14:09:31 -0400
Received: by mail-wr0-f170.google.com with SMTP id g76so40853175wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 11:09:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Jun 2017 12:09:29 -0600
Message-ID: <CAJCQCtRvzveHJuzRg9fqTAiPNpjAQxaZbcf+t1E65hojhzXaXQ@mail.gmail.com>
Subject: Re: btrfs native encryption
To: Filip Bystricky <filipbystricky@google.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 9, 2017 at 9:50 AM, Filip Bystricky
<filipbystricky@google.com> wrote:
> Dear btrfs maintainers,
> Google is evaluating btrfs for its potential use in android, but
> currently the lack of native file-based encryption unfortunately makes
> it a nonstarter. According to the FAQ (specifically the answer to
> "Does btrfs support encryption"), nobody is currently working on this.
> How up-to-date is that answer, and are there any new plans to add
> native FBE in the future?


The ext4 and f2fs encryption implementations were moved to the VFS, so
in theory it can be used for XFS and Btrfs. A usability gotcha that
probably is manageable on Android is dealing with inheritance of
encryption when making snapshots, and dealing with reflinks.

https://lwn.net/Articles/677620/

-- 
Chris Murphy
