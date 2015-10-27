Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:32961 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbbJ0I4A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 04:56:00 -0400
Received: by pabla5 with SMTP id la5so23471828pab.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 01:56:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$f1907$281e469a$9ad1b02d$53b95aea@cox.net>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com> <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com> <pan$f1907$281e469a$9ad1b02d$53b95aea@cox.net>
From: "cheater00 ." <cheater00@gmail.com>
Date: Tue, 27 Oct 2015 09:55:40 +0100
Message-ID: <CA+9GZUhfM6hMrWY9F1TKtyNaXxPqdSrPt5m8BWU=SEkhAQx4ng@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No, sadly the intervals don't seem to be regular like that.

On Tue, Oct 27, 2015 at 7:39 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> cheater00 . posted on Tue, 27 Oct 2015 03:00:05 +0100 as excerpted:
>
>> currently my computer freezes every several seconds for half a second or
>> so. Using it feels like I'm playing musical chairs with the kernel.
>> I have just one download happening on utorrent right now - this is what
>> the graph looks like:
>> http://i.imgur.com/LqhMtrJ.png and every time a new spike happens, a
>> freeze happens just before that... that's the only time those freezes
>> happen, too.
>
> Is it perchance every 30 seconds?  (The graph seems to indicate more like
> 50 second cycles, but...)
>
> Because that's btrfs' normal commit time.  If it is, there's a mount
> option to change the commit time (the wiki says commit=N, N=30 by
> default, since kernel 3.12).  You could try fiddling with that, say
> setting it to 15 or 60, not necessarily to fix the problem (tho 60
> seconds might increase the problem while making it less frequent, while
> 15 might make it more frequent but less of a problem), but to see if the
> cycle changes with the commit time option, or stays @ 30 seconds.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
