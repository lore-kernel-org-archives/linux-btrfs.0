Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55416 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdJUCbc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 22:31:32 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e5jZK-0003pb-0v
        for linux-btrfs@vger.kernel.org; Sat, 21 Oct 2017 04:31:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: SLES 11 SP4: can't mount btrfs
Date: Sat, 21 Oct 2017 02:31:02 +0000 (UTC)
Message-ID: <pan$be6d8$a8cd8915$6095c5b3$10773679@cox.net>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
        <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
        <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
        <00a601d349c8$8bde60d0$a39b2270$@helmholtz-muenchen.de>
        <00c501d349d2$df72aa30$9e57fe90$@helmholtz-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lentes, Bernd posted on Fri, 20 Oct 2017 20:40:15 +0200 as excerpted:

> Is it generally possible to restore a btrfs partition from a tape backup
> ?
> I'm just starting, and I'm asking myself. What is about the subvolumes ?
> This information isn't stored in files, but in the fs ? This is not on a
> file-based backup on a tape.

Yes it's possible to restore a btrfs partition from tape backup, /if/ you 
backed up the partition itself, not just the files on top of it.

Otherwise, as you deduce, you get the files, but not the snapshot history 
or relationship, nor the subvolumes, which will look to normal file-level 
backup software (that is, backup software not designed with btrfs-
specifics like subvolumes, which if it did, would likely use btrfs send/
receive at least optionally) like normal directories.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

