Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50757 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KMQ0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Nov 2012 11:26:09 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so5023204wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2012 08:26:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121109100227.GF9133@yeono.kjorling.se>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
 <5099C40C.6030003@jp.fujitsu.com> <509A5E4F.7090408@giantdisaster.de>
 <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com>
 <509BEC60.9080200@giantdisaster.de> <20121109100227.GF9133@yeono.kjorling.se>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Tue, 13 Nov 2012 17:25:46 +0100
Message-ID: <CAGy7UtjTVC+-_xv1pMB9O3RZan_-1Z1qA5W=56MwJDJZASO1qA@mail.gmail.com>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

I gave your patchset a whirl and it worked like a charm. Thanks a lot
for your work. I was confused for a moment by the fact that the
operation doesn't immediately resize btrfs to use all of the new
device's available space. But after a bit of thought I suppose that is
intentional to make it easy to return to a device of similar size as
the original.

One suggestion remains: I would prefer the operation to leave some
record of what has happened in the system log. Other operations like
device add and device delete do and I think it makes sense to have a
log trail of such invasive operations on the filesystem.

Tested-by: Bart Noordervliet <bart@noordervliet.net>

Best regards,

Bart
