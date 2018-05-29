Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36139 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965010AbeE2Rch (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 13:32:37 -0400
MIME-Version: 1.0
From: shankarapailoor <shankarapailoor@gmail.com>
Date: Tue, 29 May 2018 10:32:35 -0700
Message-ID: <CAB+yDaaXoeQ_hVVVvQ6y+gpa+XSH2YScwp1gR-Rz-2aSQUj74g@mail.gmail.com>
Subject: BUG in mm/page-writeback.c:2652
To: Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am fuzzing linux 4.17-rc4 with BTRFS and I encountered a BUG in
mm/page-writeback.c error described below. This bug has occured 3
times in our fuzzing campaign.

Here is the full stack trace: https://pastebin.com/QcDi9xA2

Truncated Stack Trace: https://pastebin.com/GWRNmhmC

Here is a C reproducer: https://pastebin.com/xTAVB3L2

My linux configs: https://pastebin.com/6J1KMczH

It appears that there is a fault injection inside of create_io_em
during the slab allocation for the path. After that
extent_clear_unlock_delalloc gets called. I don't know if the
extent_map start and end are well defined in this case.

Regards,
Shankara Pailoor
