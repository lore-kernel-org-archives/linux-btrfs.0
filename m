Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:46425 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbeCJSj5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 13:39:57 -0500
Message-ID: <1520707193.24363.39.camel@scientia.net>
Subject: Re: zerofree btrfs support?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Roman Mamedov <rm@romanrm.net>, Adam Borowski <kilobyte@angband.pl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 19:39:53 +0100
In-Reply-To: <20180310233127.0dfa7823@natsu>
References: <1520650525.5641.47.camel@scientia.net>
         <20180310081606.7c2u2dtopijujhbz@angband.pl>
         <1520691545.24363.10.camel@scientia.net> <20180310193722.2d6b494a@natsu>
         <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
         <20180310233127.0dfa7823@natsu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2018-03-10 at 23:31 +0500, Roman Mamedov wrote:
> QCOW2 would add a second layer of COW
> on top of
> Btrfs, which sounds like a nightmare.

I've just seen there is even a nocow option "specifically" for btrfs...
it seems however that it doesn't disable the CoW of qcow, but rather
that of btrfs... (thus silently also the checksumming).


Does plain qcow2 really CoW on every write? I've always assumed it
would only CoW when one makes snapshots or so...


Cheers,
Chris.
