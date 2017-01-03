Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935514AbdACQG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 11:06:29 -0500
Date: Tue, 3 Jan 2017 17:06:13 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no
 arguments
Message-ID: <20170103160613.GP12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170103115813.GA3228@fedori>
 <20170103144602.GN12081@twin.jikos.cz>
 <CAKuJGC9TZJqVCrQG4nWvss+VuzaGKVjn=Pk+FmhvGOa0xSh3wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKuJGC9TZJqVCrQG4nWvss+VuzaGKVjn=Pk+FmhvGOa0xSh3wQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 03, 2017 at 08:58:44PM +0530, Lakshmipathi.G wrote:
> Sorry about the misleading subject line. This patch is for missing
> optional arguments.
> 
> Before the patch:
> $ ./btrfs-debugfs /mnt/file.txt   # Does nothing and silently fails.
> 
> After the patch:
> $ ./btrfs-debugfs /mnt/file.txt
> No arguments passed. Type 'btrfs-debugfs -h' for usage.

That still looks confusing to me, as I'd count /mnt/file.txt as an
argument. Even -h lists all the -h/-b/-f as optional arugments.
