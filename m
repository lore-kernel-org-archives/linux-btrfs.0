Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51604 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdKUW2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 17:28:31 -0500
Subject: Re: Kernel 4.14 RAID5 multi disk array on bcache not mounting
To: Andy Leadbetter <andy.leadbetter@theleadbetters.com>,
        linux-btrfs@vger.kernel.org
References: <CAJUWh6odg=eAxmQk_+gvrMkqrptEpykd4EB54_tF31grELsGgQ@mail.gmail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <3527f0ed-941e-d736-c472-23ce11699cbd@bouton.name>
Date: Tue, 21 Nov 2017 23:22:03 +0100
MIME-Version: 1.0
In-Reply-To: <CAJUWh6odg=eAxmQk_+gvrMkqrptEpykd4EB54_tF31grELsGgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/11/2017 à 23:04, Andy Leadbetter a écrit :
> I have a 4 disk array on top of 120GB bcache setup, arranged as follows
[...]
> Upgraded today to 4.14.1 from their PPA and the

4.14 and 4.14.1 have a nasty bug affecting bcache users. See for example
:
https://www.reddit.com/r/linux/comments/7eh2oz/serious_regression_in_linux_414_using_bcache_can/

Lionel
