Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:40649 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaFTIAl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 04:00:41 -0400
Message-ID: <53A3EA25.2020400@suse.cz>
Date: Fri, 20 Jun 2014 10:00:37 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        kamal.mostafa@canonical.com
CC: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y][SRU][PATCH 0/1] btrfs: fix defrag 32-bit integer overflow
References: <cover.1403107937.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1403107937.git.joseph.salisbury@canonical.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2014 07:23 PM, Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1324953
> 
> 
> Hello,
> 
> Please consider including upstream commit c41570c9 in the next v3.13.y release.  It was included upstream as of v3.14-rc2.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1324953 .
> 
> commit c41570c9d29764f797fa35490d72b7395a0105c3
> Author: Justin Maggard <jmaggard10@gmail.com>
> Date:   Tue Jan 21 11:18:29 2014 -0800
> 
>     btrfs: fix defrag 32-bit integer overflow

Now in 3.12.

Thanks.

-- 
js
suse labs
