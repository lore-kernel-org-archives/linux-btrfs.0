Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:55783 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbeEUNtw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 09:49:52 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Tomasz Pala <gotar@polanet.pl>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware =?iso-8859-1?Q?defragmentation=3F?=
Date: Mon, 21 May 2018 15:49:48 +0200
MIME-Version: 1.0
Message-ID: <c14bf34c-101a-4dc9-a74f-b154837f7c5e@linuxsystems.it>
In-Reply-To: <20180520105928.GA17117@polanet.pl>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <20180518235530.GA12463@polanet.pl>
 <06bf88aa-c585-45ac-a670-b81f3f747ce6@linuxsystems.it>
 <20180520105928.GA17117@polanet.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On domenica 20 maggio 2018 12:59:28 CEST, Tomasz Pala wrote:
> On Sat, May 19, 2018 at 10:56:32 +0200, Niccol? Belli wrote:
>> snapper users with hourly snapshots will not have any use for it.
> Anyone with hourly snapshots anyone is doomed anyway.

I do not agree: having hourly snapshots doesn't mean you cannot limit 
snapshots at a reasonable number. In fact you can simply keep a dozen of 
them, then start discarding the older ones.
