Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47121 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752502AbcIDKaw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Sep 2016 06:30:52 -0400
Message-Id: <1472985050.1817194.715218329.7F4E8977@webmail.messagingengine.com>
From: Francesco Turco <fturco@fastmail.fm>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: OOM killer and Btrfs
Date: Sun, 04 Sep 2016 12:30:50 +0200
In-Reply-To: <20160904100625.GA305@x4>
References: <1472983177.1812484.715201857.036A622E@webmail.messagingengine.com>
 <20160904100625.GA305@x4>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 4, 2016, at 12:06, Markus Trippelsdorf wrote:
> On 2016.09.04 at 11:59 +0200, Francesco Turco wrote:
> > Is the problem already known? Should I report a bug? Is there a patch I
> > can try? Thanks.
> 
> This issue was recently fixed by:
> 
> commit 6b4e3181d7bd5ca5ab6f45929e4a5ffa7ab4ab7f
> Author: Michal Hocko <mhocko@suse.com>
> Date:   Thu Sep 1 16:14:41 2016 -0700
> 
>     mm, oom: prevent premature OOM killer invocation for high order
>     request
> 
> It will be backported to the 4.7.x stable kernel, too.

Great, I will wait for a new 4.7.x release then :)

Thank you for the info!

-- 
https://www.fturco.net/
