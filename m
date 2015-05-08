Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33862 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbbEHK1K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 06:27:10 -0400
Received: by iget9 with SMTP id t9so28327886ige.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 03:27:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <554C8BD7.4090706@oracle.com>
References: <554C8BD7.4090706@oracle.com>
Date: Fri, 8 May 2015 11:27:10 +0100
Message-ID: <CAL3q7H5M=jDB-9O0TPpMO6VUQzHteVAa73SadJBTHz95Q+Qukg@mail.gmail.com>
Subject: Re: btrfs-progs Makefile in gitignore ?
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 8, 2015 at 11:11 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
>
> btrfs-progs/.gitignore
> ::
> Makefile
> Documentation/Makefile
>
> why ?

Why not?
Autotools generates Makefile from Makefile.in (or a Makefile.am in
other setups).

Every single project I've ever seen using autotools has Makefile
listed in .gitignore.

Examples:

https://github.com/apache/couchdb/blob/1.6.x/.gitignore
https://github.com/memcached/memcached/blob/master/.gitignore
(...)


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
