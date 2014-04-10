Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42301 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDJQBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 12:01:31 -0400
Received: by mail-pb0-f50.google.com with SMTP id md12so4155722pbc.9
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 09:01:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3414746.Gera7uWrI1@fuchsia>
References: <4783411.VVGoQz5kVU@fuchsia>
	<CAPpBBdMCAFASLgGpbWo7-Pp74S_KQdZ2A7qrSNzo0rGrZAbqMw@mail.gmail.com>
	<pan$2aca0$96a1810f$3919e968$6678f073@cox.net>
	<3414746.Gera7uWrI1@fuchsia>
Date: Thu, 10 Apr 2014 18:01:31 +0200
Message-ID: <CAPpBBdNo0ar8+2Kt9O_mNyQsmmOvFNfVJ=a_EA1HW=TnS4uTXQ@mail.gmail.com>
Subject: Re: Copying a disk containing a btrfs filesystem
From: George Eleftheriou <eleftg@gmail.com>
To: Michael Schuerig <michael.lists@schuerig.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> What makes the case complicate is
> not the question how to preserve and copy the current data; it's how to
> retain the historic data embodied in snapshots.
>
You can always rsync (incrementally with --link-dest) to "another
place" the sequence of snapshots, provided of course there is enough
space in this "other place". However I understand this may not be the
coolest thing to do especially taking into account the SMART warnings
for imminent deterioration.

On Thu, Apr 10, 2014 at 5:15 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> claim, I really should have thought of and mentioned the restoring from
> backups method first, instead of having it occur to me as an after-
> thought.  I must be getting sloppy and careless in my thinking! =:^( )

Maybe this is related to the fact that btrfs is maturing, gradually
causing you a sense of complete safety ;-)
