Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:28914 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883AbaCOA3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 20:29:38 -0400
Date: Sat, 15 Mar 2014 02:29:33 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: scrub: don't call unlock if
 pthread_mutex_lock fails
Message-ID: <20140315002933.GA29539@localhost.localdomain>
References: <20140314234943.GA28451@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20140314234943.GA28451@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Forgot to mention the reason for change. If accepted this can be
included in commit message:

On Sat, Mar 15, 2014 at 01:49:45AM +0200, Rakesh Pandit wrote:
> If pthread_mutex_lock fails (rare but fix it anyway), don't call
> pthread_mutex_unlock on mutex.
>

Rationale being that if pthread_mutex_lock fails pthread_mutex_unlock
will always fail and overwrite actual error value in err.
 
> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>

regards,
