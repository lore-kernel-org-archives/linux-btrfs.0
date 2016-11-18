Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34114 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753626AbcKRMNE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 07:13:04 -0500
Received: by mail-yw0-f194.google.com with SMTP id a10so19785593ywa.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 04:13:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4c85dfa5-9dbe-ea3c-7816-1ab321931e1c@suse.cz>
References: <bug-186671-27@https.bugzilla.kernel.org/> <20161103115353.de87ff35756a4ca8b21d2c57@linux-foundation.org>
 <b5b0cef0-8482-e4de-cb81-69a4dd3410fb@suse.cz> <CAJtFHUQcJKSnyQ7t7-eDpiF2C+U23+iWpZ+X6fGEzN8qdbzmtA@mail.gmail.com>
 <a8cf869e-f527-9c65-d16d-ac70cf66472a@suse.cz> <CAJtFHUQgkvFaPdyRcoiV-m5hynDGo2qXfMXzZvGahoWp2LL_KA@mail.gmail.com>
 <bbcd6cb7-3b73-02e9-0409-4601a6f573f5@suse.cz> <CAJtFHUSka8nbaO5RNEcWVRi7VoQ7UORWkMu_7pNW3n_9iRRdew@mail.gmail.com>
 <CAJtFHUTn9Ejvyj3vJkqnsLoa6gci104-TPu5viG=epfJ9Rk_qg@mail.gmail.com> <4c85dfa5-9dbe-ea3c-7816-1ab321931e1c@suse.cz>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Fri, 18 Nov 2016 13:13:03 +0100
Message-ID: <CANznX5G_UmUpH4U6S8qWcrKt5q9zNOLdkHwPuj7pxgoUocrFeg@mail.gmail.com>
Subject: Re: [Bug 186671] New: OOM on system with just rsync running 32GB of
 ram 30GB of pagecache
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It could be totally unrelated but I have a similar problem: processes
get randomly OOM'd when I am doing anything "sort of heavy" on my
Btrfs filesystems.
I did some "evil tuning", so I assumed that must be the problem (even
if the values looked sane for my system). Thus, I kept cutting back on
the manually set values (mostly dirty/background ratio, io scheduler
request queue size and such tunables) but it seems to be a dead end. I
guess anything I change in order to try and cut back on the related
memory footprint just makes the OOMs less frequent but it's only a
matter of time and coincidence (lots of things randomly happen to do
some notable amount of IO) until OOMs happen anyway.
It seems to be plenty enough to start a defrag or balance on more than
a single filesystem (in parallel) and pretty much any notable "useful"
user load will have a high change of triggering OOMs (and get killed)
sooner or later. It's just my limited observation but database-like
loads [like that of bitcoind] (sync writes and/or frequent flushes?)
or high priority buffered writes (ffmpeg running with higher than
default priority and saving live video streams into files without
recoding) seem to have higher chance of triggering this (more so than
simply reading or writing files sequentially and asynchronously,
either locally or through Samba).
I am on gentoo-sources 4.8.8 right now but it was there with 4.7.x as well.

On Thu, Nov 17, 2016 at 10:49 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 11/16/2016 02:39 PM, E V wrote:
>> System panic'd overnight running 4.9rc5 & rsync. Attached a photo of
>> the stack trace, and the 38 call traces in a 2 minute window shortly
>> before, to the bugzilla case for those not on it's e-mail list:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=186671
>
> The panic screenshot has only the last part, but the end marker says
> it's OOM with no killable processes. The DEBUG_VM config thus didn't
> trigger anything, and still there's tons of pagecache, mostly clean,
> that's not being reclaimed.
>
> Could you now try this?
> - enable CONFIG_PAGE_OWNER
> - boot with kernel option: page_owner=on
> - after the first oom, "cat /sys/kernel/debug/page_owner > file"
> - provide the file (compressed, it will be quite large)
>
> Vlastimil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
