Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38640 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbCaWRJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 18:17:09 -0400
Received: by igbqf9 with SMTP id qf9so30656455igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 15:17:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRn4sjDV1skkpJBjwjfXr18F502Q9G6p_4ZdRg27J4bXg@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
	<b5hrub-586.ln1@hurikhan77.spdns.de>
	<CAJCQCtRn4sjDV1skkpJBjwjfXr18F502Q9G6p_4ZdRg27J4bXg@mail.gmail.com>
Date: Tue, 31 Mar 2015 16:17:08 -0600
Message-ID: <CAJCQCtRZuUvmYnZh1_UV7nEkT4rFZprzhs3qfFx1yQCJYBOJ0w@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 4:15 PM, Chris Murphy <lists@colorremedies.com> wrote:

> The i915 regression right now is really annoying. With a Samsung 840
> EVO I've  had inexplicable and non-deterministic boot failures.

Clarification: the boot failures happen following the i915 panic and
subsequent forced power off.


-- 
Chris Murphy
