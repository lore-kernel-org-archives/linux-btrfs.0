Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:39068 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdBHXTQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 18:19:16 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id C8A619B819
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 23:19:13 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 9F0585FBB3
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2017 23:19:13 +0000 (GMT)
Subject: Re: BTRFS and cyrus mail server
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <24389268.gAX5gEpECb@libor-nb>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <460c6ae5-c11b-ef6b-ee5b-7c75a2af0b71@cobb.uk.net>
Date: Wed, 8 Feb 2017 23:19:13 +0000
MIME-Version: 1.0
In-Reply-To: <24389268.gAX5gEpECb@libor-nb>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/17 18:38, Libor Klepáč wrote:
> I'm interested in using:
...
>  - send/receive for offisite backup

I don't particularly recommend that. I do use send/receive for onsite
backups (I actually use btrbk). But for offsite I use a traditional
backup tool (I use dar). For three main reasons:

1) Paranoia: I want a backup that does not use btrfs just in case there
turned out to be some problem with btrfs which could corrupt the backup.
I can't think of anything but I did say it was paranoia!

2) send/receive in incremental mode (the obvious way to use it for
offsite backups) relies on the target being up to date and properly
synchronised with the source. If, for any reason, it gets out of sync,
you have to start again with sending a full backup - a lot of data.
Traditional backup formats are more forgiving and having a corrupted
incremental does not normally prevent you getting access to data stored
in the other incrementals. This would particularly be a risk if you
thought about storing the actual send streams instead of doing the
receive: a single bit error in one could make all the subsequent streams
useless.

3) send/receive doesn't work particularly well with encryption. I store
my offsite backups in a cloud service and I want them encrypted both in
transit and when stored. To get the same with send/receive requires
putting together your own encrypted communication channel (e.g. using
ssh) and requires that you have a remote server, with an encrypted
filesystem receiving the data (and it has to be accessible in the clear
on that server). Traditional backups can just be stored offsite as
encrypted files without ever having to be in the clear anywhere except
onsite.

Just my reasons.

