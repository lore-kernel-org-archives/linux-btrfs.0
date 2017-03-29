Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35137 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755445AbdC2MLu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 08:11:50 -0400
Received: by mail-qt0-f176.google.com with SMTP id x35so10330278qtc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2017 05:11:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
References: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at> <22744.8089.282234.241186@tree.ty.sabi.co.uk>
 <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 29 Mar 2017 15:11:48 +0300
Message-ID: <CAA91j0WkPi5dM8unAY7-rnAnuc4qWu4Qr7tUEf6MWxpPTO3jGg@mail.gmail.com>
Subject: Re: send snapshot from snapshot incremental
To: =?UTF-8?Q?Jakob_Sch=C3=BCrz?= <wertstoffe@nurfuerspam.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 1:01 AM, Jakob Schürz <wertstoffe@nurfuerspam.de> wrote:
>
> There is Subvolume A on the send- and the receive-side.
> There is also Subvolume AA on the send-side from A.
> The parent-ID from send-AA is the ID from A.
> The received-ID from A on received-side A is the ID from A.
>
> To send the AA, i use the command
> btrfs send -p A AA|btrfs receive /path/to/receiveFS/
>
> The received-ID from AA on received-side A is the ID from AA.
>
>
> Now i take a snapshot from AA on the send-side -> Called AAA
>
> If i try to send AAA to the receiving FS with
> btrfs send -p AA AAA|btrfs receive /path/to/receiveFS/
> no parent snapshot is found.

I cannot reproduce it. Please show exact command invocations, ideally
starting with creation of A.
