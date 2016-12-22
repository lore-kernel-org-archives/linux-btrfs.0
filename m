Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:54044 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757463AbcLVKqe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 05:46:34 -0500
To: nholland@tisys.org, mhocko@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, clm@fb.com,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20161220020829.GA5449@boerne.fritz.box>
        <20161221073658.GC16502@dhcp22.suse.cz>
        <20161222101028.GA11105@ppc-nas.fritz.box>
        <20161222102725.GG6048@dhcp22.suse.cz>
        <20161222103524.GA14020@ppc-nas.fritz.box>
In-Reply-To: <20161222103524.GA14020@ppc-nas.fritz.box>
Message-Id: <201612221946.EHB81270.FVHFMLSQOOtJFO@I-love.SAKURA.ne.jp>
Date: Thu, 22 Dec 2016 19:46:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nils Holland wrote:
> Well, the issue is that I could only do everything via ssh today and
> don't have any physical access to the machines. In fact, both seem to
> have suffered a genuine kernel panic, which is also visible in the
> last few lines of the log I provided today. So, basically, both
> machines are now sitting at my home in panic state and I'll only be
> able to resurrect them wheh I'm physically there again tonight.

# echo 10 > /proc/sys/kernel/panic
