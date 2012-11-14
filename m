Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:19939 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2KNLmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 06:42:55 -0500
Message-ID: <50A383BE.8000301@giantdisaster.de>
Date: Wed, 14 Nov 2012 12:42:54 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Bart Noordervliet <bart@noordervliet.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <5099C40C.6030003@jp.fujitsu.com> <509A5E4F.7090408@giantdisaster.de> <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com> <509BEC60.9080200@giantdisaster.de> <20121109100227.GF9133@yeono.kjorling.se> <CAGy7UtjTVC+-_xv1pMB9O3RZan_-1Z1qA5W=56MwJDJZASO1qA@mail.gmail.com>
In-Reply-To: <CAGy7UtjTVC+-_xv1pMB9O3RZan_-1Z1qA5W=56MwJDJZASO1qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 13 Nov 2012 17:25:46 +0100, Bart Noordervliet wrote:
> Hi Stefan,
> 
> I gave your patchset a whirl and it worked like a charm. Thanks a lot
> for your work. I was confused for a moment by the fact that the
> operation doesn't immediately resize btrfs to use all of the new
> device's available space. But after a bit of thought I suppose that is
> intentional to make it easy to return to a device of similar size as
> the original.

Yes, replace and resize is an operation that intentionally requires two
manual steps, since the step backwards, to shrink a device, can take a
long time.


> One suggestion remains: I would prefer the operation to leave some
> record of what has happened in the system log. Other operations like
> device add and device delete do and I think it makes sense to have a
> log trail of such invasive operations on the filesystem.

That's a good idea. I have now added such KERN_INFO log messages.



> Tested-by: Bart Noordervliet <bart@noordervliet.net>

Thanks for testing and for your feedback :)

