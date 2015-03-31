Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33469 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbbCaULT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 16:11:19 -0400
Received: by iebmp1 with SMTP id mp1so18749187ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 13:11:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
Date: Tue, 31 Mar 2015 14:11:18 -0600
Message-ID: <CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Martin Langhoff <martin.langhoff@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 2:09 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Well you have to rule that out before anyone on this list can really
> help. Try booting Fedora 21 install media, and using smartctl -x on
> the drive.

While you're at it, try to mount the Btrfs volume in question normally
and report kernel messages. If mount fails, try it with -o recovery
mount option, and also report kernel messages and whether that fails.

-- 
Chris Murphy
