Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33570 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933189AbdEWCH6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 22:07:58 -0400
Received: by mail-yw0-f178.google.com with SMTP id p73so57436254ywp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 19:07:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170522235754.GJ29894@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org> <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org> <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
 <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com> <20170522235754.GJ29894@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 May 2017 20:07:57 -0600
Message-ID: <CAJCQCtR52d2EPgEGPNYDMf3zy7vV-5Yud_k3kVFDrb0JD80PKg@mail.gmail.com>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 5:57 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, May 22, 2017 at 05:26:25PM -0600, Chris Murphy wrote:
>> On Mon, May 22, 2017 at 10:31 AM, Marc MERLIN <marc@merlins.org> wrote:
>>
>> >
>> > I already have 24GB of RAM in that machine, adding more for the real
>> > fsck repair to run, is going to be difficult and ndb would take days I
>> > guess (then again I don't have a machine with 32 or 48 or 64GB of RAM
>> > anyway).
>>
>> If you can acquire an SSD, you can give the system a bunch of swap,
>> and at least then hopefully the check repair can complete. Yes it'll
>> be slower than with real RAM but it's not nearly as bad as you might
>> think it'd be, based on HDD based swap.
>
> Oh, swap will work, you're sure?
> I already have an SSD, if that's good enough, I can give it a shot.

Yeah although I have no idea how much swap is needed for it to
succeed. I'm not sure what the relationship is to fs metadata chunk
size to btrfs check RAM requirement is; but if it wants all of the
metadata in RAM, then whatever btrfs fi us shows you for metadata may
be a guide (?) for how much memory it's going to want.

Another possibility is zswap, which still requires a backing device,
but it might be able to limit how much swap to disk is needed if the
data to swap out is highly compressible. *shrug*

-- 
Chris Murphy
