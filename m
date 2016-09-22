Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33224 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934082AbcIVDMX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 23:12:23 -0400
Received: by mail-oi0-f65.google.com with SMTP id w11so5260133oia.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 20:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5381630f-594b-63f9-0958-261cd9562240@cn.fujitsu.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com> <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com> <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
 <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com> <CAJCQCtQMZFnHhD0v0Qtwyh=MgeiMZjuWODY5unVLSVEUQMNYDQ@mail.gmail.com>
 <5381630f-594b-63f9-0958-261cd9562240@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Sep 2016 21:12:14 -0600
Message-ID: <CAJCQCtQHTQuWBBRivjPJjmh6pwTCQXOAH4vSSuchog6Jru=7MQ@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 9:00 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

>> Both copies are not scrubbed? Oh hell...
>
>
> I was replying to the "--check-data-csum" of btrfsck.
>
> I mean, for --check-data-csum, it doesn't read the backup if the first data
> can be read out without error.
>
> And if the first data is wrong, btrfsck will read backup, and output error
> about wrong csum, but won't return error.

OK I'm convinced both progs and kernel scrubs have problems. I guess
it makes sense to fix progs first, and make sure it's fixed there,
then get it fixed in the kernel.



-- 
Chris Murphy
