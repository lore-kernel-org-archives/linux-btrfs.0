Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54542 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaJBWLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 18:11:53 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FIBMAP unsupported
Date: Fri, 03 Oct 2014 00:11:25 +0200
Message-ID: <6603452.o3OqIjYaDr@ax5200p>
In-Reply-To: <2356843.HqzAreCEMf@ax5200p>
References: <6602102.lhBckFYBLs@fb07-iapwap2> <20141002172549.GV11436@twin.jikos.cz> <2356843.HqzAreCEMf@ax5200p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 02 Oktober 2014, 21:55:55 schrieb Marc Dietrich:
> Will try to restore the file using btrfs restore....

ok, restore worked. I did some more tests. This is unrelated to CoW. It seems 
that the "fallocate -n" in combination with "dd conv=notrunc" using large 
files (>10G) triggers it. Maybe this rings some bells.

Marc

