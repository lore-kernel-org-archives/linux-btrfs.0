Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752AbcBDOOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 09:14:54 -0500
Date: Thu, 4 Feb 2016 15:14:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] fs: btrfs: Replace CURRENT_TIME by
 current_fs_time()
Message-ID: <20160204141436.GB9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
 <1454479670-8204-11-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454479670-8204-11-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 02, 2016 at 10:07:50PM -0800, Deepa Dinamani wrote:
> CURRENT_TIME macro is not appropriate for filesystems as it
> doesn't use the right granularity for filesystem timestamps.
> Use current_fs_time() instead.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org

Reviewed-by: David Sterba <dsterba@suse.com>

There's no actual change for btrfs as it uses granularity 1 which is a
no-op and equivalent to CURRENT_TIME.
