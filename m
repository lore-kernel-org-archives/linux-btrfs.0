Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:32872 "EHLO mx.demfloro.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbcCaI40 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 04:56:26 -0400
In-Reply-To: <20160331062112.GT9342@torres.zugschlus.de>
References: <20160331062112.GT9342@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: How to cancel btrfs balance on unmounted filesystem
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Date: Thu, 31 Mar 2016 11:16:45 +0300
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
CC: linux-btrfs@vger.kernel.org
Message-ID: <97866533-957D-4FFC-A1FF-A75B4AD7B06A@demfloro.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.
There is no tool to disable balance on unmounted filesystem. But you can use mount option skip_balance for this.


-------- Original Message --------
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
Sent: March 31, 2016 9:21:12 AM GMT+03:00
To: linux-btrfs@vger.kernel.org
Subject: How to cancel btrfs balance on unmounted filesystem

Hi,

one of my problem btrfs instances went into a hung process state
while blancing metadata. This process is recorded in the file system
somehow and the balance restarts immediately after mounting the
filesystem with no chance to issue a btrfs balance cancel command
before the system hangs again.

Is there any possiblity to cancel the pending balance without mounting
the fs first?

I have also filed https://bugzilla.kernel.org/show_bug.cgi?id=115581
to adress this in a more elegant way.

Greetings
Marc


