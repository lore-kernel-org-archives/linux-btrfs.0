Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:58988 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLFFMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Dec 2014 00:12:05 -0500
Received: by mail-yk0-f180.google.com with SMTP id 9so903501ykp.39
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 21:12:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5481F91B.6090700@terminalsystems.com>
References: <5481F91B.6090700@terminalsystems.com>
Date: Fri, 5 Dec 2014 22:12:04 -0700
Message-ID: <CAJCQCtTy9SRj1pX4wdQ83hDKf3JU4RfJ9wWTU=+JYbsYd-xiRw@mail.gmail.com>
Subject: Re: Possibility to have a "transient" snapshot?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 5, 2014 at 11:27 AM, James West <james@terminalsystems.com> wrote:

> General idea would be to have a transient snapshot (optional quota support
> possibility here) on top of a base snapshot (possibly readonly). On system
> start/restart (whether clean or dirty), the transient snapshot would be
> flushed, and the system would restart the snapshot, basically restarting
> from the base snapshot.

Sounds similar to this idea:
http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html

About 1/3 of the way down it gets to a proposal to Btrfs as a way to
get to a stateless system, which is basically what you want to be able
to rollback to. A variation on this that might serve the use case
better is seed device. You can either drop the added device that
stores changes to the seed device, or the volume (seed+added device)
can become another seed if you want to make the current state
persistent at next boot.

And still another possibility is overlayfs, which isn't Btrfs specific.



-- 
Chris Murphy
