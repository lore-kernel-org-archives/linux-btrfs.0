Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54751 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933444AbeE2N1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 09:27:11 -0400
Received: by mail-wm0-f68.google.com with SMTP id f6-v6so40574726wmc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 06:27:11 -0700 (PDT)
MIME-Version: 1.0
From: shankarapailoor <shankarapailoor@gmail.com>
Date: Tue, 29 May 2018 06:27:10 -0700
Message-ID: <CAB+yDaZe_8Lxi15g8t-t3PBAOsk5TcLpmp3zBb-kSva=R1hxTQ@mail.gmail.com>
Subject: Possible deadlock in btrfs_alloc_data_chunk_ondemand
To: clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am fuzzing 4.17-rc4 with BTRFS using Syzkaller and found a possible
deadlock. This crash has happened 3 times in an hour.

Stack Trace: https://pastebin.com/1mjA9fzv
Kernel Configs: https://pastebin.com/6J1KMczH


I don't have a reproducer yet, unfortunately.


Regards,
Shankara Pailoor

P.S. sorry if you received this email twice. First time I forgot to
make the email plain text and it was rejected.
