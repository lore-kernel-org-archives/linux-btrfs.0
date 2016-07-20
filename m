Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35974 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbcGTT64 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 15:58:56 -0400
Received: by mail-oi0-f68.google.com with SMTP id d204so5778853oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jul 2016 12:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com> <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Jul 2016 13:58:54 -0600
Message-ID: <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 17, 2016 at 3:08 AM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Well, btrfs does write data very different to many other file systems. On
> every write the file is copied to another place, even if just one bit is
> changed. That's special and I am wondering whether that could cause
> problems.

It depends on the application. In practice, the program most
responsible for writing the file often does a faux-COW by writing a
whole new (temporary) file somewhere, when that operation completes,
it then deletes the original, and move+renames the temporary one into
place where the original one, doing fsync in between each of those
operations. I think some of this is done via VFS also. It's all much
more metadata centric than what Btrfs would do on its own.

I'd expect the write pattern of Btrfs to be similar to f2fs, with
respect to sequentiality of new writes.


-- 
Chris Murphy
