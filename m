Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-relay07-dus.antispameurope.com ([94.100.134.207]:48385 "EHLO
	mx-relay07-dus.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbcGFOxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 10:53:30 -0400
Date: Wed, 6 Jul 2016 16:53:25 +0200
From: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
To: <antonio@gnu.org>
CC: <linux-btrfs@vger.kernel.org>, <bug-tar@gnu.org>, <ahferroin7@gmail.com>,
        <adilger@dilger.ca>
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
Message-ID: <577d1b65.pxyPJIXK4jVojlar%Joerg.Schilling@fokus.fraunhofer.de>
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>
 <577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>
 <78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com>
 <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
 <577D191F.90709@gnu.org>
In-Reply-To: <577D191F.90709@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Antonio Diaz Diaz <antonio@gnu.org> wrote:

> Joerg Schilling wrote:
> > POSIX requires st_blocks to be != 0 in case that the file contains data.
>
> Please, could you provide a reference? I can't find such requirement at 
> http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_stat.h.html

	blkcnt_t st_blocks      Number of blocks allocated for this object.

It should be obvious that a file that offers content also has allocated blocks.

Blocks are "allocated" when the OS decides whether the new data will fit on the 
medium. The fact that some filesystems may have data in a cache but not yet on 
the medium does not matter here. This is how UNIX worked since st_block has 
been introduced nearly 40 years ago. 

A new filesystem cannot introduce new rules just because people believe it would 
save time.



Jörg

-- 
 EMail:joerg@schily.net                    (home) Jörg Schilling D-13353 Berlin
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.org/private/ http://sourceforge.net/projects/schilytools/files/'
