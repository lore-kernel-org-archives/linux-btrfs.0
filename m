Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60612 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdLNF6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 00:58:20 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ePMX5-0007pB-Id
        for linux-btrfs@vger.kernel.org; Thu, 14 Dec 2017 06:58:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG?] Defrag on compressed FS do massive data rewrites
Date: Thu, 14 Dec 2017 05:58:04 +0000 (UTC)
Message-ID: <pan$8770b$4eaee1a7$24cc02ce$7f0c8e7b@cox.net>
References: <CAGqmi76womfiPa_EkKiJ-BgxEcU1GjK7efrh8bWVD0kD+C9NrQ@mail.gmail.com>
        <CAGqmi74-Tap-K1xc4w9rUtVBZ7toesDgr3DiG_CjPSH86YbYmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Thu, 14 Dec 2017 02:05:35 +0300 as excerpted:

> Also, same problem exist for autodefrag case i.e.:
> write 4KiB at start of compressed file autodefrag code add that file to
> autodefrag queue, call btrfs_defrag_file, set range from start to u64-1.
> That will trigger to full file rewrite, as all extents are smaller then
> 256KiB.
> 
> (if i understood all correctly).

If so, it's rather ironic, because that's how I believed autodefrag to 
work, whole-file, for quite some time.  Then I learned otherwise, but I 
always enable both autodefrag and compress=lzo on all my btrfs, so it 
looks like at least for my use-case, I was correct with the whole-file 
assumption after all.  (Well, at least for files that are actually 
compressed, I don't run compress-force=lzo, just compress=lzo, so a 
reasonable number of files aren't actually compressed anyway, and they'd 
do the partial-file rewrite I had learned to be normal.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

