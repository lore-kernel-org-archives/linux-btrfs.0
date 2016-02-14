Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33818 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbcBNUnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 15:43:06 -0500
Received: by mail-io0-f170.google.com with SMTP id 9so141058015iom.1
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 12:43:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160212160441.GH2763@merlins.org>
References: <20160212160441.GH2763@merlins.org>
Date: Sun, 14 Feb 2016 13:43:05 -0700
Message-ID: <CAJCQCtT6P15w-uhoYSb038-UJk+8ggpEF0D84CzJt2Ue_ZCaeA@mail.gmail.com>
Subject: Re: btrfs on top of bcache on top of dmcrypt on top of md raid5
From: Chris Murphy <lists@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use all defaults for everything. Anything new by show should do the
right thing including 4096 byte alignment.

gargamel:~# cryptsetup luksDump /dev/md8
[snip]
Payload offset: 3072

This is a bit weird because the default is 4096. But because the LUKS
offset (header + payload + extra unused space) is 2MiB, so it doesn't
affect alignment. There may be unpatched (fixes not backported) in the
tools of current long term supported distros, that can cause
misalignment. Probably top concern would be parted/libparted, which
would start partition 1 at LBA 63, which is not aligned. The upstream
tools for a long time now have set partition 1 to LBA 2048, but these
crusty old unpatched versions just seem to persist like a booger you
can't flick off. It's really annoying - this idea of "stable bugs"
that go on and on for a decade.



Chris Murphy
