Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:45386 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752394AbeA3Nqu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 08:46:50 -0500
Date: Tue, 30 Jan 2018 14:46:49 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130134649.GA7126@polanet.pl>
References: <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
 <6804d30d-53ff-403f-1eac-ac5da01509f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <6804d30d-53ff-403f-1eac-ac5da01509f7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 08:05:42 -0500, Austin S. Hemmelgarn wrote:

> Seriously, _THERE IS A RACE CONDITION IN SYSTEMD'S CURRENT HANDLING OF 
> THIS_.  It's functionally no different than prefacing an attempt to send 
> a signal to a process by checking if the process exists, or trying to 
> see if some other process is using a file that might be locked by 

Seriously, there is a race condition on train stations. People check if
the train has stopped and opened the door before they move their legs to
get in, but the train might be already gone - so this is pointless.

Instead, they should move their legs continuously and if the train is
not on the station yet, just climb back and retry.


See the difference? I hope now you know what is the race condition.
It is the condition, where CONSEQUENCES are fatal.


mounting BEFORE volume is complete is FATAL - since no userspace daemon
would ever retrigger the mount and the system won't came up. Provide one
btrfsd volume manager and systemd could probably switch to using it.

mounting AFTER volume is complete is FINE - and if the "pseudo-race" happens
and volume disappears, then this was either some operator action, so the
umount SHOULD happen, or we are facing some MALFUNCION, which is fatal
itself, not by being a "race condition".

-- 
Tomasz Pala <gotar@pld-linux.org>
