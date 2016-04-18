Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:40375 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbcDROLd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 10:11:33 -0400
Subject: Re: RAID5 Unable to remove Failing HD
To: Anand Jain <anand.jain@oracle.com>, Rene Castberg <rene@castberg.org>,
        linux-btrfs@vger.kernel.org
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
 <56BAFC15.6080106@oracle.com> <5714A1F7.3050509@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5714EB12.5060103@bouton.name>
Date: Mon, 18 Apr 2016 16:11:30 +0200
MIME-Version: 1.0
In-Reply-To: <5714A1F7.3050509@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 18/04/2016 10:59, Lionel Bouton a écrit :
> [...]
> So the obvious thing to do in this circumstance is to delete the drive,
> forcing the filesystem to create the missing replicas in the process and
> only reboot if needed (no hotplug). Unfortunately I'm not sure of the
> conditions where this is possible (which kernel version supports this if
> any ?). If there is a minimum kernel version where device delete works,
> can https://btrfs.wiki.kernel.org/index.php/Gotchas be updated ? I don't
> have a wiki account yet but I'm willing to do it myself if I can get
> reliable information.

Note that whatever the best course of action is I think the wiki should
probably be updated with clear instructions on that. I'm willing to
document this myself and probably other Gotchas (like how to fix a
4-device RAID10 filesystem when one of them fails based on the recent
discussion I've seen here) but I'm not sure I know all the details and
wouldn't want to put incomplete information in the wiki so I'll wait for
answers before starting to work on this.

The data on this filesystem isn't critical and I have backups for the
most important files so I can live with a "degraded" state for a while
until I'm sure of the best way to proceed.

Best regards,

Lionel Bouton
