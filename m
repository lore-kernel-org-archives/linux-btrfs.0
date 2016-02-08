Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbcBHPJK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 10:09:10 -0500
Date: Mon, 8 Feb 2016 16:08:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: dsterba@suse.cz, linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] fs: btrfs: Replace CURRENT_TIME by
 current_fs_time()
Message-ID: <20160208150850.GK9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
 <1454479670-8204-11-git-send-email-deepa.kernel@gmail.com>
 <20160204141436.GB9136@twin.jikos.cz>
 <CABeXuvqBYcgrMzjqesz+m37A3UzxCixkWvg8OyO5AdraMnQu-Q@mail.gmail.com>
 <20160207075720.GB4786@deepa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160207075720.GB4786@deepa-ubuntu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 06, 2016 at 11:57:21PM -0800, Deepa Dinamani wrote:
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
