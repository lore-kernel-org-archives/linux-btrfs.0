Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:33001 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeFHEUx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2018 00:20:53 -0400
Received: by mail-lf0-f53.google.com with SMTP id y20-v6so17977318lfy.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 21:20:52 -0700 (PDT)
Subject: Re: in which directions does btrfs send -p | btrfs receive work
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <5fff45c2188e6a73c48c7fed95f297e7f0af0dc3.camel@scientia.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <b51cdfa9-2ebd-5840-2d33-6a576f34130f@gmail.com>
Date: Fri, 8 Jun 2018 07:20:49 +0300
MIME-Version: 1.0
In-Reply-To: <5fff45c2188e6a73c48c7fed95f297e7f0af0dc3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.06.2018 05:50, Christoph Anton Mitterer пишет:
> Hey.
> 
> Just wondered about the following:
> 
> When I have a btrfs which acts as a master and from which I make copies
>  of snapshots on it via send/receive (with using -p at send) to other
> btrfs which acts as copies like this:
> master +--> copy1
>        +--> copy2
>        \--> copy3
> and if now e.g. the device of master breaks, can I move *with
> incremential send -p / receive backups from one of the copies?
> 
> Which of the following two would work (or both?):
> 
> A) Redesignating a copy to be a new master, e.g.:
>    old-copy1/new-master +--> new-disk/new-copy1
>

What is old-copy1? You never told how it was created.


>    +--> copy2
>                         \--> copy3
>    Obviously at least
> send/receiving to new-copy1 shoud work,
>    but would that work as well
> to copy2/copy3 (with -p), since they're
>    based on (and probably using
> UUIDs) from the snapshot on the old
>    broken master?
> 
> B) Let a new device be the master and move on from that (kinda creating
>    a "send/receive cycle":
>    1st:
>    copy1 +--> new-disk/new-master
> 
>    from then on (when new snapshots should be incrementally sent):
>    new-master +--> copy1
>               +--> copy2
>               \--> copy3

It is again not clear - you want to overwrite exiting copy1, copy2,
copy3? Do these copyN have any relation to copyN in the beginning of
your message? Or just want to start new incremental replication from
scratch?

>    Again, not sure whether send/receiving to copy2/3 would work, since
>    they're based on snapshots/parents from the old broken master.
>    And I'm even more unsure, whether this back&forth send/receiving,
>    from copy1->new-master->copy1 would work.
> 
> 
> Any expert having some definite idea? :-)
> 
> Thanks,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

