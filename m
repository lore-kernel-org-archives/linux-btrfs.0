Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34594 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbcK2FOb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 00:14:31 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cBakL-0004Yj-K7
        for linux-btrfs@vger.kernel.org; Tue, 29 Nov 2016 06:14:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Not TLS] Re: mount option nodatacow for VMs on SSD?
Date: Tue, 29 Nov 2016 05:14:18 +0000 (UTC)
Message-ID: <pan$a292d$fa229462$80743716$b85be0fd@cox.net>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
        <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
        <20161128003829.GD15348@rus.uni-stuttgart.de>
        <pan$1eaab$d4d4facd$e2735d04$2fc4a8e@cox.net>
        <2df2e8e6-5ac4-a9c0-70bc-406fd84e9784@cobb.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Cobb posted on Mon, 28 Nov 2016 09:49:33 +0000 as excerpted:

> On 28/11/16 02:56, Duncan wrote:
>> It should still be worth turning on autodefrag on an existing somewhat
>> fragmented filesystem.  It just might take some time to defrag files
>> you do modify, and won't touch those you don't, which in some cases
>> might make it worth defragging those manually.  Or simply create new
>> filesystems, mount them with autodefrag, and copy everything over so
>> you're starting fresh, as I do.
> 
> Could that "copy" be (a series of) send/receive, so that snapshots and
> reflinks are preserved?  Does autodefrag work in that case or does the
> send/receive somehow override that and end up preserving the original
> (fragmented) extent structure?

Very good question that I don't know the answer to as I've not seen it 
discussed previously.  (I'm not a dev, just a list regular and user of 
btrfs myself, and my personal use-case involves neither snapshots nor 
send/receive, so on those topics if I've not seen it covered previously 
either here or on the wiki, I won't know.)

Someone else know?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

