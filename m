Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36735 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbcCWBlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 21:41:14 -0400
Received: by mail-wm0-f52.google.com with SMTP id r129so116732252wmr.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 18:41:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTnGyMBwGwDowm7+4DFN89YtEJx=hmi_K4gpogx3gFanQ@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
 <CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
 <CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com> <CAJCQCtTnGyMBwGwDowm7+4DFN89YtEJx=hmi_K4gpogx3gFanQ@mail.gmail.com>
From: Ryan Erato <rerato@gmail.com>
Date: Tue, 22 Mar 2016 18:40:52 -0700
Message-ID: <CAC7HdqkBiH5Tx_Prj6R-W_PepTEA+N_+nKiqumHJS5kQ+s1p6A@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Finally got around to running the suggested commands. Same error with
the send, but not much output to help.  The check operation did seem
to reveal some potential issues. Here's the play-by-play along with
the file output from check:

[liveuser@localhost /]$ sudo btrfs check /dev/sda6 >
/home/liveuser/btrfscheck.txt
checking extents
checking free space cache
checking fs roots
root 257 inode 13324701 errors 200, dir isize wrong
root 258 inode 226392 errors 200, dir isize wrong
root 258 inode 236055 errors 2000, link count wrong
unresolved ref dir 226392 index 35 namelen 7 name LOG.old filetype 0
errors 3, no dir item, no dir index
root 258 inode 236273 errors 2000, link count wrong
root 258 inode 236276 errors 2000, link count wrong
unresolved ref dir 226392 index 39 namelen 15 name MANIFEST-000015
filetype 0 errors 3, no dir item, no dir index
root 258 inode 236277 errors 2000, link count wrong
unresolved ref dir 226392 index 41 namelen 7 name CURRENT filetype 0
errors 3, no dir item, no dir index
root 258 inode 240618 errors 2000, link count wrong
unresolved ref dir 226392 index 115 namelen 10 name 000089.log
filetype 0 errors 3, no dir item, no dir index
root 487 inode 13324701 errors 200, dir isize wrong
root 488 inode 226392 errors 200, dir isize wrong
root 488 inode 236055 errors 2000, link count wrong
unresolved ref dir 226392 index 35 namelen 7 name LOG.old filetype 0
errors 3, no dir item, no dir index
root 488 inode 236273 errors 2000, link count wrong
root 488 inode 236276 errors 2000, link count wrong
unresolved ref dir 226392 index 39 namelen 15 name MANIFEST-000015
filetype 0 errors 3, no dir item, no dir index
root 488 inode 236277 errors 2000, link count wrong
unresolved ref dir 226392 index 41 namelen 7 name CURRENT filetype 0
errors 3, no dir item, no dir index
root 488 inode 240618 errors 2000, link count wrong
unresolved ref dir 226392 index 115 namelen 10 name 000089.log
filetype 0 errors 3, no dir item, no dir index


" btrfscheck.txt
Checking filesystem on /dev/sda6
UUID: 6bb38bce-d824-4b9c-8b03-adad460c0f97
found 79333650514 bytes used err is 1
total csum bytes: 60906940
total tree bytes: 1530494976
total fs tree bytes: 1392934912
total extent tree bytes: 59506688
btree space waste bytes: 343045471
file data blocks allocated: 97137004544
 referenced 85008084992


[liveuser@localhost /]$ sudo mount /dev/sda6 /mnt/hdd

[liveuser@localhost /]$ sudo btrfs send -vvv --no-data -f homesnap.btr
/mnt/hdd/home/home.snap/
Mode NO_FILE_DATA enabled
At subvol /mnt/hdd/home/home.snap/
ERROR: send ioctl failed with -2: No such file or directory



On Sun, Mar 20, 2016 at 10:42 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Mar 20, 2016 at 10:34 PM, Ryan Erato <rerato@gmail.com> wrote:
> .
>>
>> Sending "home.snap" to "/mnt/ssd" results in the -2 error. What is
>> peculiar, or possibly a red herring, is that it seems to fail at the
>> same point each time, at 4.39GB in to the transfer.
>
>
>
> That's pretty suspicious. I didn't realize from the first description
> that the command is doing something for a while before failing. I
> thought it was failing immediately.
>
> Try this:
>
> btrfs send -vvv --no-data -f homesnap.btr home.snapshot
>
> That will write out metadata only to a file, no receive. See if the
> error still happens and if the extra v gives more info.
>
> If it still fails with no more useful information then what I'd try
> next is a btrfs check with the most recent btrfs-progs you can find.
> If you're in need of a suggestion, this has btrfs-progs 4.4.1, I've
> tested that it boots, it's got a published sha256 hash, and is served
> over https. Yes, it's not even an alpha, but all you're doing is a
> check, not a --repair, and no need to mount it (although that's
> probably safe also, I've been doing it most of the weekend).
> https://dl.fedoraproject.org/pub/alt/stage/24_Alpha-1.6/Workstation/x86_64/iso/
> dd that iso file to a USB stick, it will destroy all data on the
> stick, and then boot the computer, and switch to tty2 (control-alt-f2)
> to get to a shell.
>
> I think 'btrfs check > btrfscheck.txt' will output most of the results
> to a text file. Often it misses the first few lines for whatever
> reason. You can either 'fpaste <filename>' and then note the URL and
> post it here, or you can scp the file elsewhere, if you have wired
> ethernet connected.
>
>
> --
> Chris Murphy
