Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44770 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeA3EoZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 23:44:25 -0500
Received: by mail-oi0-f48.google.com with SMTP id b3so3918719oib.11
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 20:44:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180129085404.GA2500@polanet.pl>
References: <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me> <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl> <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net> <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl> <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 29 Jan 2018 21:44:23 -0700
Message-ID: <CAJCQCtSx89hjvQ+030KOPx5Xb2bbW8xc8w0zOf=V3A-QXtvMQg@mail.gmail.com>
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 1:54 AM, Tomasz Pala <gotar@polanet.pl> wrote:
> On Sun, Jan 28, 2018 at 17:00:46 -0700, Chris Murphy wrote:
>
>> systemd can't possibly need to know more information than a person
>> does in the exact same situation in order to do the right thing. No
>> human would wait 10 minutes, let alone literally the heat death of the
>> planet for "all devices have appeared" but systemd will. And it does
>
> We're already repeating - systemd waits for THE btrfs-compound-device,
> not ALL the block-devices. Just like it 'waits' for someone to plug USB
> pendrive in.

Btrfs is orthogonal to systemd's willingness to wait forever while
making no progress. It doesn't matter what it is, it shouldn't wait
forever.

It occurs to me there are such systemd service units specifically for
waiting for example

systemd-networkd-wait-online.service, systemd-networkd-wait-online -
Wait for network to
       come online

 chrony-wait.service - Wait for chrony to synchronize system clock

NetworkManager has a version of this. I don't see why there can't be a
wait for Btrfs to normally mount, just simply try to mount, it fails,
wait 10, try again, wait 10 try again. And then fail the unit so we
end up at a prompt. Or some people can optionally ask for a mount -o
degraded instead of a fail, and then if that also doesn't work, the
unit fails. Of course service units can have such conditionals rather
than waiting forever.





-- 
Chris Murphy
