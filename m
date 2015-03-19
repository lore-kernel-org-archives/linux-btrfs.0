Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbbCSHSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 03:18:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YYUix-0003pw-Il
	for linux-btrfs@vger.kernel.org; Thu, 19 Mar 2015 08:18:35 +0100
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 08:18:35 +0100
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 08:18:35 +0100
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: syntax for deleting subvolumes?
Date: Thu, 19 Mar 2015 09:18:29 +0200
Message-ID: <m49y4mtfoai.fsf@coffee.modeemi.fi>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<CAJCQCtQU=KzNqY=MTdqET5-J2JpDrS+O9EE50o9aXbRCJHU+xQ@mail.gmail.com>
	<550A08AC.7070506@graphitesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

K Richard Pixley <rpixley@graphitesystems.com> writes:

> But as a user level facility, I want to be able to snapshot before
> making a change to a tree full of source code and (re)building it all
> over again.  I may want to keep my new build, but I may want to flush
> it and return to known good state.

You may want to check out cp --reflink=always (different from cp
--link), which creates copy-on-write copy of the data. It isn't quite as
fast as snapshots to create, but it's still plenty fast and without the
downsides of subvolumes.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

