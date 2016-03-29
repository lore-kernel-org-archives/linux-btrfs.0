Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:33975 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbcC2LzJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 07:55:09 -0400
Received: by mail-ig0-f193.google.com with SMTP id av4so2280184igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 04:55:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZUHasMi3hoz_AwH3-gJj=HJcNnLqZeLPwQV1YRXOByrA@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
	<CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
	<CAJCQCtQcX+U1cWz1j3Re5E-=ruPBY+zj0SFqB1jDibgeQniSVw@mail.gmail.com>
	<CAAafysE+5tS=k9GFoKyqwK6dJtR4g3Eqairt1cGatCfCxooXeg@mail.gmail.com>
	<CAJCQCtTURu4OJbTfpKzQGAz4g32yaxToPaE9r8+xWt19AYJUig@mail.gmail.com>
	<CAAafysFa8XZgKvKXQqcnZYR8DLbFe3STQA3Y++Wb71PPdf+iuw@mail.gmail.com>
	<CAJCQCtQwc4FDcTPq2mfN7wfUNp9QWEq+XTJA+FEyY4hWrHvHQQ@mail.gmail.com>
	<CAAafysHw3ws3HVgyfN6YVwFN5pru_kuajKev6sQN6+_uprGiRQ@mail.gmail.com>
	<CAJCQCtQzu2X16L_jp7k-Sy8=+ScCekoHEACajcATX_-vMvDwUA@mail.gmail.com>
	<CAAafysGfah-O+CaX0eHKvzsyR52zCW5c6PExajOz16J8XpLzGQ@mail.gmail.com>
	<CAAafysEua=5bDFa=-_Co4YG+LU_kj3B4e7HnfSrE0jox5cNmhg@mail.gmail.com>
	<CAPmG0jZUHasMi3hoz_AwH3-gJj=HJcNnLqZeLPwQV1YRXOByrA@mail.gmail.com>
Date: Tue, 29 Mar 2016 07:55:08 -0400
Message-ID: <CAAafysGoG7+UmDCqM3XA==U0LrPUgzV-P3NQ_dSo1CFB=DsVAg@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: Henk Slager <eye1tm@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I think it is best that you just repeat the fixing again on the real
> disks and just make sure you have an uptodate/latest kernel+tools when
> fixing the few damaged files.
> With   btrfs inspect-internal inode-resolve 257 <path>
> you can see what file(s) are damaged.

I inspected the damaged files, they are base directories on the two
file systems that definitely don't have issues seen by btrfs replace:

ubuntu@btrfs-recovery:~$ sudo btrfs inspect-internal inode-resolve 257
/mnt/@home
/mnt/@home/aidan
ubuntu@btrfs-recovery:~$ sudo btrfs inspect-internal inode-resolve 257 /mnt/@
/mnt/@/home

I've completed recovery using the stock 4.5 kernel.org kernel. I'm
running a scrub now and it's going well so far.

Once someone authorizes my wiki account request I will update the wiki
with information on using replace instead of add/delete as well as
setting up overlay devices for filesystem recovery testing.

Thanks to everyone on the list and irc for their help with my problems.

-JohnF
