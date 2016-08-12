Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36422 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbcHLTiA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 15:38:00 -0400
Received: by mail-oi0-f47.google.com with SMTP id f189so47110665oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 12:38:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471028417.16857.12.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 12 Aug 2016 13:37:59 -0600
Message-ID: <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2016 at 1:00 PM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> Em Sex, 2016-08-12 às 12:02 -0600, Chris Murphy escreveu:
>> Tons of unallocated space. What kernel messages do you get for the
>> enospc? It sounds like this will be one of the mystery -28 error file
>> systems. So far as I recall the only work around is recreating the
>> file system. There are two additional things you can try: mount with
>> enospc_debug mount option and see if you can gather more information
>> about the problem. Or try a 4.8rc1 kernel which as a large number of
>> enospc changes.
>>
>>
>
> Unfortunately no log was written due to the lack of space :)

a. journalctl -f in a Terminal window or tab should still record
everything. So long as the OS isn't totally face planting when the
enospc happens, you may still be able to copy paste it into a file
that you can save on another file system volume. It might have some
noisy messages from systemd-journald being unable to flush to disk but
the enospc itself should all be in the window even though they don't
get committed to disk.

b. Modify /etc/systemd/journald.conf so that Storage=volatile and now
the journal is only in memory, and you can flush it to another file
system yourself with something like 'journalctl -b -o short-monotonic
> journal.log'

c. create a ~1GiB separate file system and mount it at /var/log/

d. Run journalctl -f from a 2nd computer.



> Next time it happens, I will take a screenshot of the message.

Maybe. enospc_debug tends to spit out more than the usual amount of
stuff that'll fit on a single screen.

> Do you
> think that if I reinstall my openSUSE it will be fixed?

Probably but the nature of this probem isn't well understood as far as
I know. It's not that common or it'd be easy for a dev to reproduce
and then figure out what's going on.


-- 
Chris Murphy
