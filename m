Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:56690 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935408AbcJ0QHz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 12:07:55 -0400
Received: from [10.8.0.114] (vpn.jtek.fr [188.40.135.225])
        by mail.bouton.name (Postfix) with ESMTP id 1C548B893
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 18:07:52 +0200 (CEST)
Subject: Re: Compression and device replace on raid10 kernel panic on 4.4.6
 and 4.6.x
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
 <e7707a30-e715-8a6f-c3ad-0e9171951f34@bouton.name>
 <eef3fc06-8283-33dd-cd81-f63921212105@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <1114032c-07f4-4a32-780d-be38a32b83b7@bouton.name>
Date: Thu, 27 Oct 2016 18:07:51 +0200
MIME-Version: 1.0
In-Reply-To: <eef3fc06-8283-33dd-cd81-f63921212105@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 27/10/2016 à 02:50, Lionel Bouton a écrit :
> [...]
> I'll stop for tonight and see what happens during the day. I'd like to
> try a device add / delete next but I'm worried I could end up with a
> completely unusable filesystem if the device delete hits the same
> problem than replace.
> If the replace resuming on mount crashes the system I can cancel it but
> there's no way to do so with a device delete. Or is by any chance the
> skip_balance mount option a way to cancel a delete ?

Can anyone just confirm (or infirm) that skip_balance will indeed
effectively cancel a device delete before I try something that could
force me to resort to backups ?

Lionel
