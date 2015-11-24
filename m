Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbbKXW0t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 17:26:49 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net> <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net> <5654CAE0.5040907@gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5654E427.6060708@redhat.com>
Date: Tue, 24 Nov 2015 16:26:47 -0600
MIME-Version: 1.0
In-Reply-To: <5654CAE0.5040907@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/15 2:38 PM, Austin S Hemmelgarn wrote:

> if the system was
> shut down cleanly, you're fine barring software bugs, but if it
> crashed, you should be running a check on the FS.

Um, no...

The *entire point* of having a journaling filesystem is that after a
crash or power loss, a journal replay on next mount will bring the
metadata into a consistent state.

-Eric
