Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:39273 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbeENWYW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 18:24:22 -0400
Received: by mail-ot0-f176.google.com with SMTP id l12-v6so16186069oth.6
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 15:24:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f6da1d59-c68a-9adb-464f-629b94067538@gmx.com>
References: <20180514070210.27047-1-wqu@suse.com> <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu> <CA+X5Wn6HNAz2xXSU3Rj9BqnfFCLd2EqOnWGhmjC-a4qMHzO1bQ@mail.gmail.com>
 <f6da1d59-c68a-9adb-464f-629b94067538@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 18:24:21 -0400
Message-ID: <CA+X5Wn47NrKLvB8qRKQFq8Kd7oeB2R08TPTM7WZqy2SAtM1xTw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Roman Mamedov <rm@romanrm.net>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 6:35 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> And if possible, please don't just remove those offending files (yet).
> Your binary dump would help a lot locating the root case.

Absolutely.  This is on a 50G LVM root volume, so I've been able to
leave the original one unmodified and always mounted ro.  Copied it
and changed the UUID.  So, I can leave it around for a while without a
problem.
