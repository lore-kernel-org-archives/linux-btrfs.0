Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:57451 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaHKSIe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 14:08:34 -0400
Received: by mail-la0-f53.google.com with SMTP id gl10so7126922lab.12
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 11:08:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53E90409.5050105@jrs-s.net>
References: <loom.20140811T193907-62@post.gmane.org> <53E90409.5050105@jrs-s.net>
From: Ames Cornish <ames@montebellopartners.com>
Date: Mon, 11 Aug 2014 11:08:12 -0700
Message-ID: <CAP6pX24mY4QKAJZWa+FQuqQUM+gyedo3dxp1CbvxFjFKYfSRGg@mail.gmail.com>
Subject: Re: Announcement: buttersink - like rsync for btrfs snapshots
To: Jim Salter <jim@jrs-s.net>
Cc: Ames Cornish <gmane@pub.cornishes.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim,

btrfs send reliability has been an issue, though I've been able to
successfully use it for my backups.  buttersink usually detects the
errors and will either move the destination snapshot to mark it as
partial/failed (for btrfs), or cancel and delete the partial upload
(for S3).  I've also found that it helps to wait a while (e.g. 30
seconds) after any volume deletes before trying the send/sync.  I hope
btrfs-progs will get more reliable, too.

- Ames
