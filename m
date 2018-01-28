Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:59961 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbeA1Knm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Jan 2018 05:43:42 -0500
Date: Sun, 28 Jan 2018 11:43:40 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180128104340.GA6887@polanet.pl>
References: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <CAJCQCtT8_zdmc5oTLLa7AQt5_ObQchwBvFJCNf2UkC7ygn0rXw@mail.gmail.com>
 <20180128000016.GB16927@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20180128000016.GB16927@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 28, 2018 at 01:00:16 +0100, Tomasz Pala wrote:

> It can't mount degraded, because the "missing" device might go online a
> few seconds ago.

s/ago/after/

>> The central problem is the lack of a timer and time out.
> 
> You got mdadm-last-resort@.timer/service above, if btrfs doesn't lack
> anything, as you all state here, this should be easy to make this work.
> Go ahead please.

And just to make it even easier - this is how you can react to events
inside udev (this is to eliminane btrfs-scan tool being required as it sux):

https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f

One could even try to trick systemd by SETTING (note the single '=')

ENV{ID_BTRFS_READY}="0"

- which would probably break as soon as btrfs.ko emits next 'changed' event.

-- 
Tomasz Pala <gotar@pld-linux.org>
