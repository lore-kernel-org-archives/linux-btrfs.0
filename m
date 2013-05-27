Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40886 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3E0QgP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 12:36:15 -0400
Received: by mail-vc0-f182.google.com with SMTP id gf12so4859773vcb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 09:36:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYTtuH99nqMb6589xJgwsrSG6fD02XzU3ji=dSmJokMxTw@mail.gmail.com>
References: <16735484.PAleCPYpY8@noname>
	<CAFvQSYTtuH99nqMb6589xJgwsrSG6fD02XzU3ji=dSmJokMxTw@mail.gmail.com>
Date: Mon, 27 May 2013 18:36:14 +0200
Message-ID: <CAFvQSYRjPycUL0vuKeWEUUcXQC9cUGwLT1uSz3DPFGxLYze1gA@mail.gmail.com>
Subject: Re: systemd "journalctl" is 1.89sec on ext4, 1.49 min on btrfs
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>> Journalctl on btrfs was always this slow, some btrfsck were made on the file
>> system too, but I don't think it was corrupted. On just the first run it's
>> sluggish, after it's fast as the ext4 one.

Most likely the file is heavily fragmented due to COW.
Have you tried to manually defrag the filesystem and turn on autodefrag?

Regards, Clemens
