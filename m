Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36308 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbEZRuB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 13:50:01 -0400
Received: by iepj10 with SMTP id j10so97914846iep.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 10:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150526173634.GU11340@wantstofly.org>
References: <20150526173634.GU11340@wantstofly.org>
Date: Tue, 26 May 2015 11:50:00 -0600
Message-ID: <CAJCQCtRW5ZJ9J-dq_64p+vQnWsAM+Pt8eGP+NxH_SzwSAU9mpg@mail.gmail.com>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
From: Chris Murphy <lists@colorremedies.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before wiping I suggest making an image with btrfs-image. And then
also see if any additional messages appear with the enospc_debug mount
option. And also see if there's any correlation between the journald
reported failures (the specific .journal file) and whether it's +C by
using lsattr. Fedora 21 systemd journal files do not have +C by
default, whereas Fedora 22 systemd journal files do use +C by default.
So I'd expect the journal files to be a mix. Also let us know if there
are snapshots that affect /var/log/journal (either reflink copies of
the journal files or a snapshot of the root subvolume which contains
/var/log/journal.


Chris Murphy
