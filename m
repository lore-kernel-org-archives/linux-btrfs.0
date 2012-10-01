Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34623 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2JANof (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 09:44:35 -0400
Received: by obbuo13 with SMTP id uo13so4931631obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 06:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50699A40.2030603@yahoo.com.br>
References: <1349098002.208.YahooMailNeo@web31801.mail.mud.yahoo.com>
	<50699A40.2030603@yahoo.com.br>
Date: Mon, 1 Oct 2012 20:44:34 +0700
Message-ID: <CAG1y0sf=dN_p4BWHa5h=BjXnC7U+5D=01XEa1iFFzKdJJTFmyg@mail.gmail.com>
Subject: Re: Tunning - cache write (database)
From: "Fajar A. Nugraha" <list@fajar.net>
To: Cesar Inacio Martins <cesar_inacio_martins@yahoo.com.br>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 1, 2012 at 8:27 PM, Cesar Inacio Martins
<cesar_inacio_martins@yahoo.com.br> wrote:

> My problem:
> * Using btrfs + compression , flush of 60 MB/s take 4 minutes....
> (on this 4 minutes they keep constatly I/O of +- 4MB/s no disks)
> (flush from Informix database)


> * OpenSuse 12.1 64bits, running over VmWare ESXi 5
> * Btrfs version : btrfsprogs-0.19-43.1.2.x86_64
> * Kernel : Linux jdivm06 3.1.10-1.16-desktop #1 SMP PREEMPT Wed Jun 27


> My question, what I believed will help to avoid this long flush :
> * Have some way to force this flush all in memory cache and then use the
> btrfs background process to flush to disk ...
>   Security and recover aren't a priority for now, because this is part of a
> database bulkload ...after finish , integrity will be desirable (not a
> obligation, since this is a test environment)
>
> For now, performance is the mainly requirement...


I suggest you start by reading
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18827.html

After that, PROBABLY start your database by preloading libeatmydata to
disable fsync completely.

On a side note, zfs has "sync" property, which when set to "disabled",
have pretty much the same effect as libeatmydata.

-- 
Fajar
