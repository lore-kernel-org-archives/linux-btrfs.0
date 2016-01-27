Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:59420 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbcA0IsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 03:48:21 -0500
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <56A230C3.3080100@netcologne.de>
 <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
 <56A6082C.3030007@netcologne.de>
 <CAJCQCtQ7yGpoUZOmVcoaCGMMqg6oro-0w4HjsXK=HHe9cFg+sw@mail.gmail.com>
 <CAKZK7uxdX9UBPOKButtPjqBOdVUfHdRTimP+W34fkz1h9P+wHg@mail.gmail.com>
 <CAKZK7uxOihVUSo9+LPfUxG7WawggkXSoaTbMVa3a4pkSEuxJdQ@mail.gmail.com>
 <CAJCQCtQe=X4FPzTBKBpP826nswGQyiY4sNES9GugLju3-9HARA@mail.gmail.com>
 <CAJCQCtTA4qUNX1R3Pgxq-17zAPJvwPGfO_Fo-qEy2LsQrpF+fg@mail.gmail.com>
 <56A73460.7080100@netcologne.de>
 <CAJCQCtTdDyv0PkkuHGrEpEnk5yzM1Fx1C0VUT8r7OAfU6i8Dfw@mail.gmail.com>
 <56A7CF97.6030408@gmail.com>
 <CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56A88452.6020306@netcologne.de>
Date: Wed, 27 Jan 2016 09:48:18 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTMEHcc1CnuHqS=g23tsirQv3S9cmDcHaK0WXyQrRds1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/26/2016 09:20 PM, Chris Murphy wrote:
> nyway,
> it seems reasonable to try a balance without the filters to see if
> that's a factor, because those filters are brand new in btrfs-progs
> 4.4. Granted, I'd expect they've been tested by upstream developers,
> but I don't know if there's an fstest for balance with these specific
> filters yet.

I have another box with 8 disks RAID6 on which I simply did a balance
with no newly added drives. Same issue ... VERY slow running balance
with IO nowhere near 100% utilization and many many days of runtime to
finish.


Regards

Christian
