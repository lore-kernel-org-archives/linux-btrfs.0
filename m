Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33587 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbbDRQUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 12:20:14 -0400
Received: by iecrt8 with SMTP id rt8so78974393iec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 09:20:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429312124.8371.62.camel@scientia.net>
References: <1429312124.8371.62.camel@scientia.net>
Date: Sat, 18 Apr 2015 10:20:13 -0600
Message-ID: <CAJCQCtQVjrkfPykDv5H0uC08nPq3KLu+PmV_2suoaambV1Sumw@mail.gmail.com>
Subject: Re: how to clone a btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 17, 2015 at 5:08 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> I've seen that this has been asked some times before, and there are
> stackoverflow/etc. questions on that, but none with a really good
> answer.
>
> How can I best copy one btrfs filesystem (with snapshots and subvolumes)
> into another, especially with keeping the CoW/reflink status of all
> files?
> And ideally incrementally upgrade it later (again with all
> snapshots/subvols, and again not loosing the shared blocks between these
> files).

Make the source a seed device, add new device, delete seed. Once that
completes, unmount, unset btrfs seed, and now the two devices are
separate fs volumes each with unique UUID. There may still be bugs
with seed device, it's been maybe 6 months since I last checked.


-- 
Chris Murphy
