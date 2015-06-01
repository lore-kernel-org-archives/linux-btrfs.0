Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50580 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbbFAH0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jun 2015 03:26:42 -0400
MIME-Version: 1.0
Message-ID: <trinity-dbb28c3f-406d-44a8-8e9f-46ec5cf69147-1433143591498@3capp-webde-bs11>
From: =?UTF-8?Q?=22Conch=C3=BAr_Navid=22?= <conchur@web.de>
To: "Hugo Mills" <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, "Josef Bacik" <jbacik@fb.com>
Subject: Aw: Re: Metadata size limitations of btrfs
Content-Type: text/plain; charset=UTF-8
Date: Mon, 1 Jun 2015 09:26:31 +0200
In-Reply-To: <20150528122302.GK16826@carfax.org.uk>
References: <trinity-4b189d7e-816b-4903-87ba-0cfd9972d4e4-1432801960117@3capp-webde-bs21>,
 <20150528122302.GK16826@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[...] 
> > Here the requested information of my fs (after removing a lot of build
> > directories):
> >
> > franzbroetchen# uname -a
> > Linux franzbroetchen 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux
> > franzbroetchen# btrfs --version
> > btrfs-progs v4.0
> > franzbroetchen# btrfs fi show
> > Label: 'root' uuid: 57fe2100-0510-11e5-977e-0021ccb48233
> > Total devices 1 FS bytes used 182.55GiB
> > devid 1 size 467.68GiB used 206.06GiB path /dev/mapper/franzbroetchen_vg-root
> 
> Hmm. You shouldn't be seeing any kind of ENOSPC with this
> allocation -- there's plenty of space for it to allocate from. I think
> you've hit the horrible undiagnosed bug which prevents the FS from
> allocating more space. I know josef was looking at this one but kept
> getting distracted by data-corruption issues. He may be able to
> comment more on it.
> 
> Given the information above, I'm not sure that the usage=5 or
> limit=3 suggestion I made above will have any benefit for you.

No, I've tried this in the past without any success. I think I went up to usage=90
(without any limit) and it had no affect. I would guess that the problem is
an allocation problem for the metadata because enough free space for allocation
was available.
