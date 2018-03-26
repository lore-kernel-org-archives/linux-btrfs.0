Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:50902 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbeCZOcI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 10:32:08 -0400
Message-ID: <1522074724.6830.31.camel@scientia.net>
Subject: Re: spurious full btrfs corruption
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 26 Mar 2018 16:32:04 +0200
In-Reply-To: <1521158625.4352.16.camel@scientia.net>
References: <26306A4D-2D8E-4661-B89E-9F050FD184D5@scientia.net>
         <BF03A3DF-684D-47FE-A9AD-320256F64763@scientia.net>
         <b6b4ed0e-9569-158d-19ad-82c885bab4ec@gmx.com>
         <BB977A40-847C-4611-A468-9BF1137CE711@scientia.net>
         <d2a14d69-dfa9-8794-6375-03d1b209632f@gmx.com>
         <68697875-6E77-49C4-B54E-0FADB94700DA@scientia.net>
         <99ee9b31-a38a-d479-5b1d-30e9c942d577@gmx.com>
         <A19E863A-F83C-4630-9675-4309CECB318E@scientia.net>
         <1b24e69e-2c1e-71af-fb1d-9d32f72cc78c@gmx.com>
         <8DB99A3B-6238-497D-A70F-8834CC014DCF@gmail.com>
         <c88d6721-ad20-c45d-0ac1-a49f2bab66cb@gmx.com>
         <1519833022.3714.122.camel@scientia.net>
         <8f83436a-9abb-1fd1-599f-d8034a5b3cb5@gmx.com>
         <1520297878.4428.39.camel@scientia.net>
         <0a25d1fc-38cb-8fb6-4538-6300093c0bbd@gmx.com>
         <1520519895.15491.21.camel@scientia.net>
         <1111e6a3-20fd-d3b5-8eaa-672a4a859380@gmx.com>
         <1521158625.4352.16.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Qu.

Some update on the corruption issue on my Fujitsu notebook:


Finally got around running some memtest on it... and few seconds after
it started I already got this:
https://paste.pics/1ff8b13b94f31082bc7410acfb1c6693

So plenty of bad memory...

I'd say it's probably not so unlikely that *this* was the actual reason
for btrfs-metadata corruption.

It would perfectly fit to the symptom that I saw shortly before the fs
was completely destroyed:
The spurious csum errors on reads that went away when I read the file
again.



I'd guess you also found no further issue with the v1 space cache
and/or the tree log in the meantime?
So it's probably safe to turn them on again?



We(aka you + me testing fixes) can still look in the issue that newer
btrfsprogs no longer recover anything from the broken fs, while older
to.
I can keep the image around, so no reason to hurry from your side.



Cheers,
Chris.
