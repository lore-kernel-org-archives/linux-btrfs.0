Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35359 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbcIUBAo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 21:00:44 -0400
Received: by mail-oi0-f50.google.com with SMTP id w11so42921271oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 18:00:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB1rxdbJX7rgv-NrHyGD7wMMcFf1EDR_aJ8yaTs7r=O-iXTo7w@mail.gmail.com>
References: <CAB1rxdbJX7rgv-NrHyGD7wMMcFf1EDR_aJ8yaTs7r=O-iXTo7w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 19:00:42 -0600
Message-ID: <CAJCQCtSz15HC99QetsSzJRtbLgZU+iohej9Mf6qE4q39MmZfKA@mail.gmail.com>
Subject: Re: Can't mount btrfs raid1
To: Mirak M <mirak63@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 5:16 PM, Mirak M <mirak63@gmail.com> wrote:
> Hello,
>
> I have a failure when mounting btrfs.
>
>> mount -oro,recovery /dev/sda2 sda2_btrfs
>> mount: /dev/sda2: can't read superblock

What do you get for 'btrfs super-recover -v <dev>' and 'btrfs check <dev>'

For this purpose any 4.4+ version is probably OK, except 4.7 and 4.7.1
which might spit out some bogus items (it's just noise it won't hurt
anything as long as you don't use --repair).


>
> The kernel log is here http://pastebin.com/tHihHT92 and at the bottom
> of the email
>
> I must admit I did the error of running btrfs check --repair at some
> point, not knowing this was not a good idea.
>
> I run ubuntu 16.04 with kernel 4.4.0-36-generic .

OK what version of btrrfs-progs? What was the output from btrfs check?


> [ 1692.712574] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=1957998690304,root=1, slot=29
> [ 1692.712819] BTRFS critical (device sda2): corrupt leaf, bad key
> order: block=1957998690304,root=1, slot=29

List archives suggest this might be due to bad RAM. I also see there
are some bugs that can cause it, but I'm not finding any post kernel
4.4 patches for this (there are a metric f tonne of changes since
4.4). I would suggest kernel 4.4.21 if you need to stick with a long
term kernel, I have no idea what 4.4.0-36 translates into.


> [ 1692.713963] BTRFS: error (device sda2) in btrfs_replay_log:2401:
> errno=-5 IO failure (Failed to recover log tree)

This is kinda curious, was there a crash or power failure?




-- 
Chris Murphy
