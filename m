Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:34634 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbcGFOxX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jul 2016 10:53:23 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <antonio@gnu.org>)
	id 1bKnwr-0005zE-1f
	for linux-btrfs@vger.kernel.org; Wed, 06 Jul 2016 10:37:12 -0400
Message-ID: <577D191F.90709@gnu.org>
Date: Wed, 06 Jul 2016 16:43:43 +0200
From: Antonio Diaz Diaz <antonio@gnu.org>
MIME-Version: 1.0
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
CC: ahferroin7@gmail.com, adilger@dilger.ca, linux-btrfs@vger.kernel.org,
        bug-tar@gnu.org
Subject: Re: [Bug-tar] stat() on btrfs reports the st_blocks with delay (data
 loss in archivers)
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>	<A865BDE1-B7F5-4D3B-9C0C-96E5A55B5410@dilger.ca>	<577b7dd1.tgcc3Oz1nmHZ676h%Joerg.Schilling@fokus.fraunhofer.de>	<78b3f192-ec4b-6da2-91b4-7369c5eceadc@gmail.com> <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
In-Reply-To: <577cf051.4qpBvyW8ljjUEUZn%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Joerg Schilling wrote:
> POSIX requires st_blocks to be != 0 in case that the file contains data.

Please, could you provide a reference? I can't find such requirement at 
http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_stat.h.html


Thanks.
Antonio.
