Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50895 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOPQB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 10:16:01 -0500
Date: Wed, 15 Jan 2014 07:15:45 -0800
From: Marc MERLIN <marc@merlins.org>
To: Holger Brandsmeier <brandsmeier@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: btrfsck failes
Message-ID: <20140115151545.GI10639@merlins.org>
References: <CAFP7zVtDEfDjKA1GvBq_QMs6gKv9t=K_qNyv6dcxawe5iuj8Kw@mail.gmail.com>
 <D942F4C1-471E-476F-BEC1-3090DDAEB115@colorremedies.com>
 <CAFP7zVuB=A2Lty275-VdixjzG6twXKmJo0qB3gZEH=9noQbpRQ@mail.gmail.com>
 <CAFP7zVvk_cXfCrdie9CqGpAa2y6=t4L4bn93v3kNJdudH5nDhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFP7zVvk_cXfCrdie9CqGpAa2y6=t4L4bn93v3kNJdudH5nDhw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 08:53:55AM +0100, Holger Brandsmeier wrote:
> # btrfs-zero-log /dev/sda5
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> parent transid verify failed on 602529792 wanted 23460 found 23463
> Ignoring transid failure
> btrfs-zero-log: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
> Aborted (core dumped)

I've been seeing this quite a bit too. Is this fixed already, or known
broken?

I can run under gdb next time if needed.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
