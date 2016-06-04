Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33084 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcFDCgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 22:36:17 -0400
Received: by mail-oi0-f44.google.com with SMTP id k23so154081835oih.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 19:36:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465006419.6648.54.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<f4a9ef2f-99a8-bcc4-5a8f-b022914980f0@swiftspirit.co.za>
	<1465006419.6648.54.camel@scientia.net>
Date: Fri, 3 Jun 2016 20:36:15 -0600
Message-ID: <CAJCQCtRi8C-Grcff4MaS9-amoSuAwcdMFzUooA0PQSFQQTBpMQ@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 8:13 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> If there would be e.g. an kept-up-to-date wiki page about the status
> and current perils of e.g. RAID5/6, people (like me) wouldn't ask every
> weeks, saving the devs' time.

Well up until 4.6, there was a rather clear "Btrfs is under heavy
development, and is not suitable for-any uses other than benchmarking
and review." statement in kernel documentation.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/diff/Documentation/filesystems/btrfs.txt?id=v4.6&id2=v4.5

There's no longer such a strongly worded caution in that document, nor
in the wiki.

The wiki has stale information still, but it's a volunteer effort like
everything else Btrfs related.


-- 
Chris Murphy
