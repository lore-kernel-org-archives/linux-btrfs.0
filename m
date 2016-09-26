Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33446 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbcIZAho (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 20:37:44 -0400
Received: by mail-qk0-f180.google.com with SMTP id g67so90399583qkd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Sep 2016 17:37:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <pan$afe1d$3cd285bd$f0b68da9$67150f63@cox.net> <CAGfcS_n+pMq0thNEM9b2ZA78xEpXTFJXjwTHRyvquLS8dR_yng@mail.gmail.com>
 <964e335c-76d1-f7c0-4e66-c2cabe7b9249@suse.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Sun, 25 Sep 2016 19:37:42 -0500
Message-ID: <CAGfcS_=hK1EpuBwJt1nost7=A3mgmyf3Cth0Bn10UQTtNs=fuw@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 25, 2016 at 7:22 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 9/25/16 9:55 AM, Rich Freeman wrote:
>> On Fri, Sep 23, 2016 at 12:58 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>
>>> Btrfs raid1 you say, and you have existing compressed files it's trying
>>> to read in the backtrace?
>>>
>>> Sounds like the issues I see sometimes and have posted about where after
>>> a crash that resulted in one device of my raid1 pair getting behind the
>>> other, the kernel will crash if it sees too many csum-errors, even tho
>>> it's /supposed/ to check the other copy and read from it if valid (which
>>> it is as a btrfs scrub resolves the issue).
>>>
>>> When booted to rescue/single-user mode, can you run a scrub?
>>
>> After a few reboots trying to capture the initial panic message (even
>> when I set panic_on_oops=1 I was getting multiple ones with only the
>> tainted one staying on screen), the system managed to stay up.  I
>> completed a scrub and it found no errors.  I also haven't had any
>> issues with it but haven't attempted another reboot.  I figured the
>> safest course was to just leave it on for a good week so that whatever
>> was in the log/etc that was giving it trouble works its way out.  I'm
>> also doing a balance which may or may not help (and which is useful
>> anyway since I increased the size of the drive I replaced).
>
> If it stays up, can you post the initial Oops then?
>

Unfortunately, it stays up because there is no OOPS.  It was crashing
fairly consistently, but for whatever reason it didn't this time.
Since I needed the box working and wasn't having a lot of luck
capturing the OOPS I just let it run with minimal prodding, and
hopefully it is now in a state where it won't crash.

But, if it happens again I'll try to capture an initial OOPS output,
and I'll do a memory test in any case (though I really am not
expecting anything there).

If I were able to get kernel core dumping working on this machine,
would that contain information about the initial oops.  I forget if
they contain the full ring buffer/etc.  I used to have it working but
some change in either the kernel or the utils was causing issues with
it.  I still boot my kernels with space set aside for the crash
kernel...

--
Rich
