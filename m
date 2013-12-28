Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44899 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3L1Uey (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 15:34:54 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so10084380pdj.30
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Dec 2013 12:34:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk>
 <CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
 <CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com> <CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
From: Richard Michael <rmichael@edgeofthenet.org>
Date: Sat, 28 Dec 2013 15:34:13 -0500
Message-ID: <CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
To: Emil Karlson <jekarlson@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 28, 2013 at 2:52 PM, Emil Karlson <jekarlson@gmail.com> wrote:
>> Emil, your bug report mentions the subvolume journal is different, and
>> not anything about silent content differences on file data (images,
>> databases, etc.) as you mention above.  How are they related?
>
> systemd-journald is a logging daemon in the userspace that has nothing
> to do with filesystem journal.

Ah yes, of course.  I haven't used systemd very much, and was rather
focused on filesystem terminology. (It didn't help that I ignored the
path in your shasum output; but, yes I saw it.)  Sorry!

Though, I'm left wondering what the impact is to systemd.

Is the journal on the received side useless?  I'll read details ; but
I'm guessing the "difference" is that all the used extents were
copied, but that unused but pre-allocated extents were not ; so that
the journal is still has the data systemd has written, but is missing
the empty/unused extents?  However, in that case, I'm unclear about
what sha1sum is reading vs. what systemd is reading - I suppose
systemd must know to ignore extents it has not [yet] written.

>
>> Also, how is the journal different on the receive-side?  Is it "just"
>> a size/allocation issue, as David commented on the bug report; or is
>> the content actually different? For example, can it still be used to
>> recover the filesystem post-crash?  What does "fixed in V2" mean:
>> BTRFSv2 ?
>
> Send stream format specification V2.

Ok, thanks.

(I assume the "Send stream v2 draft", here:
https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive )

Regards,
Richard
