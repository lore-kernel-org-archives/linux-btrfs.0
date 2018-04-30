Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754645AbeD3QvU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 12:51:20 -0400
Subject: Re: Strange behavior (possible bugs) in btrfs
To: Vijay Chidambaram <vvijay03@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c552d9cd-5ce9-b55c-747e-3af28ec161b8@suse.com>
Date: Mon, 30 Apr 2018 12:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/30/18 12:04 PM, Vijay Chidambaram wrote:
> Hi,
> 
> We found two more cases where the btrfs behavior is a little strange.
> In one case, an fsync-ed file goes missing after a crash. In the
> other, a renamed file shows up in both directories after a crash.

Hi Vijay -

What kernel version did you observe these with?  These seem like bugs
Filipe has already fixed.

-Jeff


> Workload 1:
> 
> mkdir A
> mkdir B
> mkdir A/C
> creat B/foo
> fsync B/foo
> link B/foo A/C/foo
> fsync A
> -- crash --
> 
> Expected state after recovery:
> B B/foo A A/C exist
> 
> What we find:
> Only B B/foo exist
> 
> A is lost even after explicit fsync to A.
> 
> Workload 2:
> 
> mkdir A
> mkdir A/C
> rename A/C B
> touch B/bar
> fsync B/bar
> rename B/bar A/bar
> rename A B (replacing B with A at this point)
> fsync B/bar
> -- crash --
> 
> Expected contents after recovery:
> A/bar
> 
> What we find after recovery:
> A/bar
> B/bar
> 
> We think this breaks rename's atomicity guarantee. bar should be
> present in either A or B, but now it is present in both.
> 
> Thanks,
> Vijay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Jeff Mahoney
SUSE Labs
