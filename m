Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:51327 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbeERRSI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 13:18:08 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware =?iso-8859-1?Q?defragmentation=3F?=
Date: Fri, 18 May 2018 19:18:05 +0200
MIME-Version: 1.0
Message-ID: <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
In-Reply-To: <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On venerdì 18 maggio 2018 19:10:02 CEST, Austin S. Hemmelgarn wrote:
> and also forces the people who have ridiculous numbers of 
> snapshots to deal with the memory usage or never defrag

Whoever has at least one snapshot is never going to defrag anyway, unless 
he is willing to double the used space.

Niccolò
