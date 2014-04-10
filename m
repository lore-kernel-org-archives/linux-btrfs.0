Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45985 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbaDJSPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 14:15:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Michael Schuerig <michael.lists@schuerig.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 20:15:18 +0200
Message-ID: <13063586.OmM7xhbOG8@merkaba>
In-Reply-To: <3414746.Gera7uWrI1@fuchsia>
References: <4783411.VVGoQz5kVU@fuchsia> <pan$2aca0$96a1810f$3919e968$6678f073@cox.net> <3414746.Gera7uWrI1@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 10. April 2014, 17:51:26 schrieb Michael Schuerig:
> On Thursday 10 April 2014 15:15:02 Duncan wrote:
> > Meanwhile (2), given the existence of those tested backups, there's
> > yet  another way to accomplish things.  Simply restore from the
> > backups the same way you would if the working copy went down and you
> > had to restore it, only restore to the new device instead of the old
> > one.  =:^)
> 
> As the OP, let me insist that I have multiple backups. However and
> unfortunately, those backups do not contain the snapshots that I'd like
> to preserve when exchanging the disk. What makes the case complicate is
> not the question how to preserve and copy the current data; it's how to
> retain the historic data embodied in snapshots.

Well I think this is scriptable – although this would be some work.

Like this – pseudo shell code without verifying exact argument order:

- for each subvolume create according subvolume in destination
- for each snapshot – from oldest to newest:
  - rsync / btrfs send snapshot
  - snapshot with same name
  - rsync next newer snapshot


I have snapshots on backup drive… so I´d probably ditch snapshots on 
production side… but if you want them… thats another idea.


Although I like the balance idea as well. I used it to RAID-1 my /home to dual 
SSD setup. But I didn´t to the degrading step.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
