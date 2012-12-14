Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46932 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2LNHQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 02:16:56 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so410223qaq.19
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2012 23:16:55 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Dec 2012 15:16:55 +0800
Message-ID: <CAKXJSOHetjwz2efvRPJnOT2M7g9eQg3rMQER0r+MshfFayifJQ@mail.gmail.com>
Subject: Can we make btrfs_defrag_file more progressive?
From: Wang Sheng-Hui <shhuiw@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

I'm reading btrfs_defrag_file to find what would "btrfs fi defrag" do
on one file.
In btrfs_defrag_file, I image one case:

      One file A, which has lots of small fragmentation, e.g < 8K (em
covers <8K mapping), and each fragmentation
is far from the other fragmentation by PAGE_CACHE_SIZE at least on the disk.

By walking the code, my conclusion is that "btrfs fi defrag" won't
gather the small fragments
together to room out big continus disk space in this case.

I wonder can we make btrfs_defrag_file more aggessive, e.g modify
            “next = defrag_lookup_extent(inode, em->start + em->len);”
to “next = defrag_lookup_extent(inode, em->start + 64 * 1024);” in
defrag_check_next_extent,
or add some param to tune the behavior?

Please advise.

Thanks,
Wang Sheng-Hui
