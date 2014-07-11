Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60078 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaGKMgd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 08:36:33 -0400
From: Russell Coker <russell@coker.com.au>
To: constantine <costas.magnuse@gmail.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and LBA errors
Date: Fri, 11 Jul 2014 22:36:30 +1000
Message-ID: <5907875.Oun3LlLFiV@xev>
In-Reply-To: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com>
References: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 11 Jul 2014 13:42:40 constantine wrote:
> Btrfs filesystem could not be mounted because /dev/sdc1 had unreadable
> sectors. It is/was  a single filesystem (not raid1 or raid0) over /dev/sda1
> and /dev/sdc1.

What does "file -s /dev/sda1 /dev/sdc1" report?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

