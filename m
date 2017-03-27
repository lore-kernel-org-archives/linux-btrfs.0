Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:55410 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752297AbdC0PGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 11:06:41 -0400
Date: Mon, 27 Mar 2017 20:06:46 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Christian Theune <ct@flyingcircus.io>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Shrinking a device - performance?
Message-ID: <20170327200646.41e82280@natsu>
In-Reply-To: <CDED0C65-B382-4EFF-90C6-140F5C8DFC0E@flyingcircus.io>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327132404.GO11714@carfax.org.uk>
        <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
        <D3C6181C-2485-4CBC-AD13-A367DD6665F2@flyingcircus.io>
        <333BD058-6365-43C3-8070-E6267936D98D@flyingcircus.io>
        <bf772a48-5181-d1ea-f7a7-5dffc524e2de@gmail.com>
        <CDED0C65-B382-4EFF-90C6-140F5C8DFC0E@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Mar 2017 16:49:47 +0200
Christian Theune <ct@flyingcircus.io> wrote:

> Also: the idea of migrating on btrfs also has its downside - the performance of “mkdir” and “fsync” is abysmal at the moment. I’m waiting for the current shrinking job to finish but this is likely limited to the “find free space” algorithm. We’re talking about a few megabytes converted per second. Sigh.

Btw since this is all on LVM already, you could set up lvmcache with a small
SSD-based cache volume. Even some old 60GB SSD would work wonders for
performance, and with the cache policy of "writethrough" you don't have to
worry about its reliability (much).

-- 
With respect,
Roman
