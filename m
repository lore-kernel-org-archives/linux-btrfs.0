Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36132 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbbHYRBb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:01:31 -0400
Received: by vkif69 with SMTP id f69so69902119vki.3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:01:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAL+OBri=u1ZWb9SN0wvUirud6hZd4w3FxocmKxF95Z=Vi86ug@mail.gmail.com>
References: <CAAL+OBri=u1ZWb9SN0wvUirud6hZd4w3FxocmKxF95Z=Vi86ug@mail.gmail.com>
Date: Tue, 25 Aug 2015 11:01:30 -0600
Message-ID: <CAJCQCtSfyAymdXwy94T7CN1+c0R9dFhzzXVG9R9bmoDCbrZP5Q@mail.gmail.com>
Subject: Re: Unmountable file system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dan@hentschels.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 9:11 AM, Dan Hentschel <dan@hentschels.com> wrote:

> Btrfs v3.12

I'd say that version of btrfs-progs is too old for reliable btrfs
check --repair to be much help and could make things worse.



> # btrfs restore /dev/mapper/kingston-streamer2 /mnt
> checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
> checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
> Csum didn't match
> offset is 20480
> failed to inflate: -3

Sounds like one of the compression related bugs, I forget when those
were fixed. Try a newer btrfs-progs for restore. If it still fails, it
should be possible to use -i to ignore the checksum errors.

https://btrfs.wiki.kernel.org/index.php/Restore

-- 
Chris Murphy
