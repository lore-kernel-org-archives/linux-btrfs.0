Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48373 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbcLDCKV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 21:10:21 -0500
Date: Sun, 4 Dec 2016 03:10:19 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Marc Joliet <marcec@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: system hangs due to qgroups
Message-ID: <20161204021019.GA25519@angband.pl>
References: <1776088.42rHLKPlSp@thetick>
 <CAJCQCtRxhjKAcZy7wuXCFM1=70eG+TJPwEoyD7zq0iEw8f2urQ@mail.gmail.com>
 <4615776.dvopQOigxY@thetick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4615776.dvopQOigxY@thetick>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 10:46:40PM +0100, Marc Joliet wrote:
> As it's a rescue shell, I have only the one shell AFAIK, and it's occupied
> by mount.  So I can't tell if there are dmesg entries, however, when this
> happens during a normal running system, I never saw any dmesg entries. 

You can use "open" (might be named "openvt") to spawn a shell on
tty2/tty3/etc.  And if you have "screen" installed, Ctrl-a c spawns new
terminals (Ctrl-a n/p/0-9 to switch).

> The output of sysrq+t is too big to capture all of it (i.e., I can't scroll 
> back to the beginning)

You may use netconsole to log everything kernel says to another machine.  I
can't provide you with the incantations from the top of my head (got working
serial (far more reliable) on all my dev boxes, and it doesn't work with
bridging ie containers on production), but as your rescue shell has no
network sharing, assuming your network card driver supports a feature
netconsole needs _and_ stars were aligned right when your network card was
manufactured, netconsole is a valuable aid.

The system might be not dead enough to stop userland network logging from
getting through, too.


Meow!
-- 
The bill declaring Jesus as the King of Poland fails to specify whether
the addition is at the top or end of the list of kings.  What should the
historians do?
