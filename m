Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932597AbeFFIqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 04:46:01 -0400
Date: Wed, 6 Jun 2018 10:45:59 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        bugzilla-daemon@bugzilla.kernel.org, bugzilla.kernel.org@plan9.de,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug 199931] New: systemd/rtorrent file data corruption when
 using echo 3 >/proc/sys/vm/drop_caches
Message-ID: <20180606084559.GD32433@dhcp22.suse.cz>
References: <bug-199931-27@https.bugzilla.kernel.org/>
 <20180605130329.f7069e01c5faacc08a10996c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605130329.f7069e01c5faacc08a10996c@linux-foundation.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 05-06-18 13:03:29, Andrew Morton wrote:
[...]
> > As for why we would do something silly as dropping the caches every hour (in a
> > cronjob), we started doing this recently because after kernel 4.4, we got
> > frequent OOM kills despite having gigabytes of available memory (e.g. 12GB in
> > use, 20GB page cache and 16GB empty swap and bang, mysql gets killed). We found
> > that that the debian 4.9 kernel is unusable, and 4.14 works, *iff* we use the
> > above as an hourly cron job, so we did that, and afterwards run into
> > rtorrent/journald corruption issues. Without the echo in place, mysql usually
> > gets oom-killed after a few days of uptime.

Do you have any oom reports to share?
-- 
Michal Hocko
SUSE Labs
