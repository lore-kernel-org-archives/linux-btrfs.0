Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43598 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3BAXJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 18:09:46 -0500
Received: by mail-ia0-f174.google.com with SMTP id o25so6062006iad.33
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Feb 2013 15:09:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359756678.6019.30.camel@boolette.noo>
References: <1359756678.6019.30.camel@boolette.noo>
Date: Fri, 1 Feb 2013 17:09:45 -0600
Message-ID: <CAE5mzvgyOqw4ddd-jsW=QxLFqb8deB5d_jiB+WOj9t5hcq8_8A@mail.gmail.com>
Subject: Re: System unmountable RW
From: cwillu <cwillu@cwillu.com>
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> then I do : mount -o rw,remount /backup/
>
> Feb  1 22:32:38 frozen kernel: [   65.780686] btrfs: force zlib compression
> Feb  1 22:32:38 frozen kernel: [   65.780700] btrfs: not using ssd allocation scheme
> Feb  1 22:32:38 frozen kernel: [   65.780706] btrfs: disk space caching is enabled
>
>
> I let that mount run days, without any success. It stay running, and I can't interrupt it (CTRL+C or kill).

Hit alt-sysrq-w at that point, and then post your dmesg; there should
be at least one stacktrace in there (possibly many), which should give
a good idea where it's hanging up.
