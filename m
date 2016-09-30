Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33401 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbcI3Sy7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 14:54:59 -0400
Received: by mail-qk0-f180.google.com with SMTP id n189so42283108qke.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Sep 2016 11:54:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Fri, 30 Sep 2016 14:54:57 -0400
Message-ID: <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 1:41 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 9/22/16 8:18 AM, Rich Freeman wrote:
>> I have been getting panics consistently after doing a btrfs replace
>> operation on a raid1 and rebooting.  I linked a photo of the panic; I
>> haven't been able to get a text capture of it.
>>
>> https://ibin.co/2vx0HhDeViu3.jpg
>>
>> I'm getting this error on the latest 4.4, 4.1, and even on an old
>> 3.18.26 kernel I had lying around.
>>
>> I tried the remove root_log_ctx from ctx list before btrfs_sync_log
>> returns patch on 4.1 and that did not solve my problem either.
>>
>> I'm able to boot into single-user mode and if I don't start any
>> processes the system seems fairly stable.  I am also able to start a
>> btrfs balance and run that for several hours without issue.  If I
>> start launching services the system will tend to panic, though how
>> many processes I can launch will vary.  I don't think that it is a
>> particular file being accessed that is triggering the issue since the
>> point where it fails varies.  I suspect it may be load-related.
>>
>> Mounting with compress=no doesn't seem to help either.  Granted, I see
>> lzo_decompress in the backtrace and that is probably a read operation.
>>
>> Any suggestions?  Google hasn't been helpful on this one...
>
> Can you boot with panic_on_oops=1, reproduce it, and capture that Oops?
> The trace in your photo is a secondary Oops (tainted D), which means
> that something else went wrong before that and now the system is
> tripping over it.  Secondary Oopses don't really help the debugging
> process because the system was already in a broken, undefined, state.
>

Ok, the system has been up for a week without issue, but just paniced
and rebooted right towards the end of a balance (it literally had
about 30 of 2500 chunks left).

After it came up (and waiting for it to fully mount as there were a
bunch of free space warnings/etc) I managed to capture an initial oops
when it happened again:

https://ibin.co/2wt0n2IaCOA3.jpg

This is on a system without swap, though my understanding is that the
paging system is used for other things.

Note that I've updated my kernel since my last post.  When it paniced
during the balance it was running 4.4.21, and on the oops I actually
captured it was on 4.4.23 (I was actually just waiting for the balance
to finish before rebooting with a new kernel).

--
Rich
