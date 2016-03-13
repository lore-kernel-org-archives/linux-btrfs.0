Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:32785 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcCMUKs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 16:10:48 -0400
Received: by mail-io0-f174.google.com with SMTP id n190so201359491iof.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 13:10:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313222442.1fa22a57@natsu>
References: <20160312204847.2092f3f3@natsu>
	<20160312221524.646e1a66@natsu>
	<20160313142428.377b51b8@natsu>
	<pan$a52ce$b1beae3d$57f5b99c$a796a0ec@cox.net>
	<20160313222442.1fa22a57@natsu>
Date: Sun, 13 Mar 2016 14:10:47 -0600
Message-ID: <CAJCQCtSnSm355BC-hVRL9NnRLxXiYQefbepvm2yfTXd6PdLghw@mail.gmail.com>
Subject: Re: parent transid verify failed on snapshot deletion
From: Chris Murphy <lists@colorremedies.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 11:24 AM, Roman Mamedov <rm@romanrm.net> wrote:

>
> "Blowing away" a 6TB filesystem just because some block randomly went "bad",

I'm going to guess it's a metadata block, and the profile is single.
Otherwise, if it were data it'd just be a corrupt file and you'd be
told which one is affected. And if metadata had more than one copy,
then it should recover from the copy. The exact nature of the loss
isn't clear, a kernel message for the time of the bad block message
might help but I'm going to guess again that it's a 4096 byte missing
block of metadata. Depending on what it is, that could be a pretty
serious hole for any file system.


> I'm running --init-extent-tree right now in a "what if" mode, using
> the copy-on-write feature of 'nbd-server' (this way the original block device
> is not modified, and all changes are saved in a separate file).

So it's a Btrfs on NDB with no replication either from Btrfs or the
storage backing it on the server? Off hand I'd say one of them needs
redundancy to avoid this very problem, otherwise it's just too easy
for even network corruption to cause a problem (NDB or iSCSI).

Not related to your problem, I'm not sure whether and how many times
Btrfs retries corrupt reads. That is, device returns read command OK
(no error), but Btrfs detects corruption. Does it retry? Or
immediately fail? For flash and network based Btrfs, it's possible the
result is intermittant so it should try again.

> It's been
> running for a good 8 hours now, with 100% CPU use of btrfsck and very little
> disk access.

Yeah btrfs check is very much RAM intensive.


-- 
Chris Murphy
