Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:59089 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaHKSIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 14:08:12 -0400
Message-ID: <53E9068B.3090005@jrs-s.net>
Date: Mon, 11 Aug 2014 14:08:11 -0400
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Ames Cornish <ames@montebellopartners.com>
CC: Ames Cornish <gmane@pub.cornishes.net>, linux-btrfs@vger.kernel.org
Subject: Re: Announcement: buttersink - like rsync for btrfs snapshots
References: <loom.20140811T193907-62@post.gmane.org> <53E90409.5050105@jrs-s.net> <CAP6pX24fWPrZ3368WxaViYT2_N2WcCWtso3KqxF_SRrDTS54xQ@mail.gmail.com> <CAP6pX26e79LZzMMwdeE7JOeGyoLtRxqvJhScBX1LDEwJ7UNe3Q@mail.gmail.com>
In-Reply-To: <CAP6pX26e79LZzMMwdeE7JOeGyoLtRxqvJhScBX1LDEwJ7UNe3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To any core btrfs devs who are listening and care - the unreliability of 
btrfs send/receive is IMO the single biggest roadblock to adoption of 
btrfs as a serious next-gen FS.

I can live with occasional corner-case performance issues, I can even 
live with (very) occasional filesystem corruption... IF I can rely on 
replication to keep my data safe on another box.  Without the 
replication, there's just no reasonable case to be made to replace ZFS.

On 08/11/2014 02:05 PM, Ames Cornish wrote:
> Jim,
>
> btrfs send reliability has been an issue, though I've been able to 
> successfully use it for my backups.  buttersink usually detects the 
> errors and will either move the destination snapshot to mark it as 
> partial/failed (for btrfs), or cancel and delete the partial upload 
> (for S3).  I've also found that it helps to wait a while (e.g. 30 
> seconds) after any volume deletes before trying the send/sync.  I hope 
> btrfs-progs will get more reliable, too.
>
> - Ames

