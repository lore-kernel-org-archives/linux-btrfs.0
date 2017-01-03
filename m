Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35392 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758737AbdACPgV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 10:36:21 -0500
Received: by mail-ua0-f195.google.com with SMTP id 96so27645663uaq.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 07:36:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170103144602.GN12081@twin.jikos.cz>
References: <20170103115813.GA3228@fedori> <20170103144602.GN12081@twin.jikos.cz>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 3 Jan 2017 20:58:44 +0530
Message-ID: <CAKuJGC9TZJqVCrQG4nWvss+VuzaGKVjn=Pk+FmhvGOa0xSh3wQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no arguments
To: dsterba@suse.cz, "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry about the misleading subject line. This patch is for missing
optional arguments.

Before the patch:
$ ./btrfs-debugfs /mnt/file.txt   # Does nothing and silently fails.

After the patch:
$ ./btrfs-debugfs /mnt/file.txt
No arguments passed. Type 'btrfs-debugfs -h' for usage.


----
Cheers,
Lakshmipathi.G
FOSS Programmer.
www.giis.co.in


On Tue, Jan 3, 2017 at 8:16 PM, David Sterba <dsterba@suse.cz> wrote:
> This is what I see when no arguments pare passed:
>
> $ ./btrfs-debugfs
> usage: btrfs-debugfs [-h] [-b] [-f] path [path ...]
> btrfs-debugfs: error: too few arguments
>
> And that's exactly the same output as with this patch applied. Am I missing
> something?
