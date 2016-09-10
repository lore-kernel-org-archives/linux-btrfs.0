Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.moparisthebest.com ([144.76.72.168]:38287 "EHLO
        mailer.moparisthebest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754091AbcIJPOM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 11:14:12 -0400
Subject: Re: btrfs kernel oops on mount
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <CAJCQCtS7y0qSsth4JwoRaCDig7nP-nRDs5ShEtudDR8JUNPaNw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: moparisthebest <admin@moparisthebest.com>
Message-ID: <57D42323.8020806@moparisthebest.com>
Date: Sat, 10 Sep 2016 11:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS7y0qSsth4JwoRaCDig7nP-nRDs5ShEtudDR8JUNPaNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2016 01:51 PM, Chris Murphy wrote:
> Also btrfs check output is useful to include also (without --repair
> for starters).

btrfs check --readonly output is here:

https://www.moparisthebest.com/btrfs/btrfscheck.txt

*Most* of it anyway, I messed up with tmux and it took 20 hours to run
so I don't really want to run it again unless you need me to.  Now that
check is over I'll try the other things suggested.
