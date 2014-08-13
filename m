Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43388 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaHMCCu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 22:02:50 -0400
Received: by mail-pa0-f48.google.com with SMTP id et14so13980878pad.21
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 19:02:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140812142423.GJ8314@merlins.org>
References: <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
	<CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
	<pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
	<A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
	<CAETJ_S_YDnJsf9Fc6+ynpBVK7MXv3RGuhhJrSVV2Tizf1J+kdA@mail.gmail.com>
	<pan$8f34b$65843f03$7e0dd88e$286fcd58@cox.net>
	<20140812142423.GJ8314@merlins.org>
Date: Tue, 12 Aug 2014 21:02:49 -0500
Message-ID: <CAETJ_S9M-s9-+szYo3r6SsdF0HUpanK=7jrG-FrWsvEpd7k7jg@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2014 at 9:24 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, Aug 12, 2014 at 04:15:26AM +0000, Duncan wrote:
>> Jose Ildefonso Camargo Tolosa posted on Mon, 11 Aug 2014 16:33:36 -0500 as
>> excerpted:
>>
>> > As I hate when a thread is left "hanging", you deserve to know what
>> > happened in the end, you likely already guessed, but anyway: I nuked the
>> > filesystem, and started over.
>> >
>> > After some internal discussion in the company, we decided to move to ZFS
>> > for now.  However, we will keep an eye on btrfs, and will likely deploy
>> > it to some smaller system for further testing.
>> >
>> > Thanks you all for your help!
>>
>> Thank you too. =:^)
>>
>> Sounds like a sane decision for the time being.
>
> Just remember that ZFS is fine for internal use, but that you can never
> ever ship any product based on ZFS due to its licensing.
>

Yeah, that's one of the reasons why we won't lose sight of btrfs, and
will try to keep at least one system with it in order to help testing
and stabilizing it.

And that's true for ZFS on Linux, but not for ZFS with FreeBSD (think:
FreeNAS).  However, I do not want to use FreeBSD for now.

Ildefonso
