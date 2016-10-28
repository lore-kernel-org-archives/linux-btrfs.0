Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:46852 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932740AbcJ1P1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:27:40 -0400
Received: from [10.8.0.114] (vpn.jtek.fr [188.40.135.225])
        by mail.bouton.name (Postfix) with ESMTP id D20E2B943
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 17:27:34 +0200 (CEST)
Subject: Re: Compression and device replace on raid10 kernel panic on 4.4.6
 and 4.6.x
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
 <e7707a30-e715-8a6f-c3ad-0e9171951f34@bouton.name>
 <eef3fc06-8283-33dd-cd81-f63921212105@bouton.name>
 <1114032c-07f4-4a32-780d-be38a32b83b7@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <26bf41dd-7168-b1c5-41b7-4f80ce297bb5@bouton.name>
Date: Fri, 28 Oct 2016 17:27:34 +0200
MIME-Version: 1.0
In-Reply-To: <1114032c-07f4-4a32-780d-be38a32b83b7@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

as I don't have much time to handle a long backup recovery, I didn't try
the delete/add combination to avoid any risk.
What I tried though, was fatal_errors=bug. As I don't have any console I
thought it might at least help log the problem instead of the usual
kernel panic.

No luck : the problem still made the kernel panic. Unless someone comes
up with a somewhat safe way to recover from this situation I'll let the
filesystem as is (we are building a new platform where redundancy will
be handled by Ceph anyway).

Lionel

Le 27/10/2016 à 18:07, Lionel Bouton a écrit :
> Hi,
>
> Le 27/10/2016 à 02:50, Lionel Bouton a écrit :
>> [...]
>> I'll stop for tonight and see what happens during the day. I'd like to
>> try a device add / delete next but I'm worried I could end up with a
>> completely unusable filesystem if the device delete hits the same
>> problem than replace.
>> If the replace resuming on mount crashes the system I can cancel it but
>> there's no way to do so with a device delete. Or is by any chance the
>> skip_balance mount option a way to cancel a delete ?
> Can anyone just confirm (or infirm) that skip_balance will indeed
> effectively cancel a device delete before I try something that could
> force me to resort to backups ?
> Lionel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

