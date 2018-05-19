Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:49738 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbeESI4j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 May 2018 04:56:39 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Tomasz Pala <gotar@polanet.pl>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware =?iso-8859-1?Q?defragmentation=3F?=
Date: Sat, 19 May 2018 10:56:32 +0200
MIME-Version: 1.0
Message-ID: <06bf88aa-c585-45ac-a670-b81f3f747ce6@linuxsystems.it>
In-Reply-To: <20180518235530.GA12463@polanet.pl>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <20180518235530.GA12463@polanet.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On sabato 19 maggio 2018 01:55:30 CEST, Tomasz Pala wrote:
> The "defrag only not-snapshotted data" mode would be enough for many
> use cases and wouldn't require more RAM. One could run this before
> taking a snapshot and merge _at least_ the new data.

snapper users with hourly snapshots will not have any use for it.
