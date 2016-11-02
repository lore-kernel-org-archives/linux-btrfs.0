Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35022 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbcKBLTR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:19:17 -0400
Received: by mail-qt0-f171.google.com with SMTP id c47so6706435qtc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:19:16 -0700 (PDT)
MIME-Version: 1.0
Reply-To: badara+ml@gmail.com
In-Reply-To: <CAKGv6CrpnfHhC8=tCcrH1+c+a0vLcLwz96gqoNCAxF6TxYD75g@mail.gmail.com>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
 <pan$af500$48f5b197$b20e4aa3$ec6e2ea2@cox.net> <CAKGv6CrpnfHhC8=tCcrH1+c+a0vLcLwz96gqoNCAxF6TxYD75g@mail.gmail.com>
From: Ahmed Badr <badara+ml@gmail.com>
Date: Wed, 2 Nov 2016 13:18:35 +0200
Message-ID: <CAN5=xXmCG0Gan5cwMtTugwvo2=orN9J8HWmJOj7k7x8PcKWwjA@mail.gmail.com>
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 2, 2016 at 8:31 AM, Alex Powell
<alexj.powellalt@googlemail.com> wrote:
> Taking a step back as well- there is also the possibility that you
> might not need snapshots

I do need it for my root partition at least in the initial phase of
setting things up and trying out different software. Once the system
is stable, I might might not need it that much.

> If you're a noobie, I assume you're not using it to host some massive
> Oracle DB and need all these features

No I'm not hosting a DB on this server. If I'm not mistaken, I believe
Btrfs's COW functionality is not suitable for DB storage anyway.
