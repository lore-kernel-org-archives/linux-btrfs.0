Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35948 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755291AbcIQLCT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 07:02:19 -0400
Received: by mail-wm0-f42.google.com with SMTP id w84so1565826wmg.1
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 04:02:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160916122148.GA17713@DigitalMercury.dynalias.net>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com> <20160916122148.GA17713@DigitalMercury.dynalias.net>
From: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Date: Sat, 17 Sep 2016 13:02:18 +0200
Message-ID: <CAA3ktqm0eSm3bM5cKsa1D-rnELTQ83rPkH-QFfEmfuBV1ZMe9A@mail.gmail.com>
Subject: Re: Size of scrubbed Data
To: Nicholas Steeves <nsteeves@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Thanks for the information. I did another run of scrubbing et voila:
total bytes scrubbed: 12.11TiB with 0 errors, which is pretty much two
times the amount of actual data stored on the filesystem. I am
relieved, but still would like to know why this went wrong in the
first place and why it is working again without me doing anything to
fix it.
Concerning Testing: I only use it on desktops and home servers, which
do not offer any services to the net. I am very fond of Debian and
always use stable or even old-stable on work servers, but was finally
to annoyed at the fact that the software I was using on a fresh
installation was practically already out of date.

Yours sincerely
Stefan

2016-09-16 14:21 GMT+02:00 Nicholas Steeves <nsteeves@gmail.com>:
> Thank you for the assistance Chris :-)
>
> On 15 September 2016 at 17:18, Chris Murphy <lists@colorremedies.com> wrote:
>>> On Thu, Sep 15, 2016 at 9:48 AM, Stefan Malte Schumacher
>>> <stefan.m.schumacher@gmail.com> wrote:
> ...
>>> I believe it may be a result of replacing my old installation of
>>> Debian Jessie with Debian Stretch
> ...
>>
>>>
>>> btrfs --version
>>> btrfs-progs v4.7.1
>>
>> Upgrade to 4.7.2 or downgrade to 4.6.1 before using btrfs check; see
>> the changelog for details. I'm not recommending that you use btrfs
>> check, just saying this version of tools is not reliable for some
>> file systems.
>
> Hi Stefan, as far as I can tell 4.7.2 is currently blocked from
> migrating from unstable to testing due to a glibc version transition,
> so the easiest thing to do is to get fall back on 4.6.1 found here:
> http://snapshot.debian.org/package/btrfs-progs/4.6.1-1/
>
>
> Cheers,
> Nicholas
>
> P.S. You're brave to run testing before the soft-freeze!  Occasionally
> security fixes in sid can't propagate to testing, because a transition
> like this is in progress ( https://www.debian.org/security/faq#testing
> ).
