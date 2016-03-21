Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34964 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCUFml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 01:42:41 -0400
Received: by mail-ig0-f175.google.com with SMTP id cl4so24997323igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 22:42:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
	<CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
	<CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com>
Date: Sun, 20 Mar 2016 23:42:40 -0600
Message-ID: <CAJCQCtTnGyMBwGwDowm7+4DFN89YtEJx=hmi_K4gpogx3gFanQ@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
From: Chris Murphy <lists@colorremedies.com>
To: Ryan Erato <rerato@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2016 at 10:34 PM, Ryan Erato <rerato@gmail.com> wrote:
.
>
> Sending "home.snap" to "/mnt/ssd" results in the -2 error. What is
> peculiar, or possibly a red herring, is that it seems to fail at the
> same point each time, at 4.39GB in to the transfer.



That's pretty suspicious. I didn't realize from the first description
that the command is doing something for a while before failing. I
thought it was failing immediately.

Try this:

btrfs send -vvv --no-data -f homesnap.btr home.snapshot

That will write out metadata only to a file, no receive. See if the
error still happens and if the extra v gives more info.

If it still fails with no more useful information then what I'd try
next is a btrfs check with the most recent btrfs-progs you can find.
If you're in need of a suggestion, this has btrfs-progs 4.4.1, I've
tested that it boots, it's got a published sha256 hash, and is served
over https. Yes, it's not even an alpha, but all you're doing is a
check, not a --repair, and no need to mount it (although that's
probably safe also, I've been doing it most of the weekend).
https://dl.fedoraproject.org/pub/alt/stage/24_Alpha-1.6/Workstation/x86_64/iso/
dd that iso file to a USB stick, it will destroy all data on the
stick, and then boot the computer, and switch to tty2 (control-alt-f2)
to get to a shell.

I think 'btrfs check > btrfscheck.txt' will output most of the results
to a text file. Often it misses the first few lines for whatever
reason. You can either 'fpaste <filename>' and then note the URL and
post it here, or you can scp the file elsewhere, if you have wired
ethernet connected.


-- 
Chris Murphy
