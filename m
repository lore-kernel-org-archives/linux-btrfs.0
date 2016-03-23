Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34361 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbcCWDem (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 23:34:42 -0400
Received: by mail-io0-f182.google.com with SMTP id m184so13593094iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 20:34:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC7HdqkBiH5Tx_Prj6R-W_PepTEA+N_+nKiqumHJS5kQ+s1p6A@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
	<CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
	<CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com>
	<CAJCQCtTnGyMBwGwDowm7+4DFN89YtEJx=hmi_K4gpogx3gFanQ@mail.gmail.com>
	<CAC7HdqkBiH5Tx_Prj6R-W_PepTEA+N_+nKiqumHJS5kQ+s1p6A@mail.gmail.com>
Date: Tue, 22 Mar 2016 21:34:41 -0600
Message-ID: <CAJCQCtQtdXXJa0AJszkoB4KR36ph2LZZ7BftNv1Qk1ksqbbKvQ@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
From: Chris Murphy <lists@colorremedies.com>
To: Ryan Erato <rerato@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 7:40 PM, Ryan Erato <rerato@gmail.com> wrote:
> Finally got around to running the suggested commands. Same error with
> the send, but not much output to help.  The check operation did seem
> to reveal some potential issues. Here's the play-by-play along with
> the file output from check:
>
> [liveuser@localhost /]$ sudo btrfs check /dev/sda6 >
> /home/liveuser/btrfscheck.txt
> checking extents
> checking free space cache
> checking fs roots
> root 257 inode 13324701 errors 200, dir isize wrong
> root 258 inode 226392 errors 200, dir isize wrong
> root 258 inode 236055 errors 2000, link count wrong
> unresolved ref dir 226392 index 35 namelen 7 name LOG.old filetype 0
> errors 3, no dir item, no dir index
> root 258 inode 236273 errors 2000, link count wrong
> root 258 inode 236276 errors 2000, link count wrong
> unresolved ref dir 226392 index 39 namelen 15 name MANIFEST-000015
> filetype 0 errors 3, no dir item, no dir index
> root 258 inode 236277 errors 2000, link count wrong
> unresolved ref dir 226392 index 41 namelen 7 name CURRENT filetype 0
> errors 3, no dir item, no dir index
> root 258 inode 240618 errors 2000, link count wrong
> unresolved ref dir 226392 index 115 namelen 10 name 000089.log
> filetype 0 errors 3, no dir item, no dir index
> root 487 inode 13324701 errors 200, dir isize wrong
> root 488 inode 226392 errors 200, dir isize wrong
> root 488 inode 236055 errors 2000, link count wrong
> unresolved ref dir 226392 index 35 namelen 7 name LOG.old filetype 0
> errors 3, no dir item, no dir index
> root 488 inode 236273 errors 2000, link count wrong
> root 488 inode 236276 errors 2000, link count wrong
> unresolved ref dir 226392 index 39 namelen 15 name MANIFEST-000015
> filetype 0 errors 3, no dir item, no dir index
> root 488 inode 236277 errors 2000, link count wrong
> unresolved ref dir 226392 index 41 namelen 7 name CURRENT filetype 0
> errors 3, no dir item, no dir index
> root 488 inode 240618 errors 2000, link count wrong
> unresolved ref dir 226392 index 115 namelen 10 name 000089.log
> filetype 0 errors 3, no dir item, no dir index

OK so now the question is if 'btrfs check --repair' can fix this, and
what version to use? 4.4.1 or 4.5.0? Based on the changelog, you can
probably use either version. And I think it should be safe. But, you
should still have backups seeing as you can mount the volume.


>
> [liveuser@localhost /]$ sudo mount /dev/sda6 /mnt/hdd
>
> [liveuser@localhost /]$ sudo btrfs send -vvv --no-data -f homesnap.btr
> /mnt/hdd/home/home.snap/
> Mode NO_FILE_DATA enabled
> At subvol /mnt/hdd/home/home.snap/
> ERROR: send ioctl failed with -2: No such file or directory

OK so there's something off with the metadata and it's not going to do
a send as a result is what this sounds like to me.


-- 
Chris Murphy
