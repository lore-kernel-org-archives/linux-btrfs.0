Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34934 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967752AbcHBPsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Aug 2016 11:48:13 -0400
Received: by mail-oi0-f41.google.com with SMTP id 4so32229660oih.2
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Aug 2016 08:48:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRDVr9MKC+GRWo1Ti4-7NLtY3Dj0gb0F=JJO1brX8bT6A@mail.gmail.com>
References: <20160731051121.GB307@x4> <20160731151047.GA4496@dhcp22.suse.cz>
 <20160731152522.GA311@x4> <20160802132855.GA24890@dhcp22.suse.cz> <CAJCQCtRDVr9MKC+GRWo1Ti4-7NLtY3Dj0gb0F=JJO1brX8bT6A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 2 Aug 2016 09:48:01 -0600
Message-ID: <CAJCQCtQ57OgNgRzjcGr4OBh3y9NO1J0juZbz5p3cgt5OinRx6A@mail.gmail.com>
Subject: Re: OOM killer invoked during btrfs send/recieve on otherwise idle machine
To: Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@suse.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 2, 2016 at 9:38 AM, Chris Murphy <lists@colorremedies.com> wrote:
> Yesterday I saw oom killer knocking off processes during a simple cp
> -a from one Btrfs to another, in a VM, with kernel
> 4.8.0-0.rc0.git3.1.fc25.x86_64. The call trace looks different than
> Markus' so I'm not sure it's the same problem. It's not always
> reproducible. It hasn't happened on 4.7.0 though. According ot koji
> this is Linux v4.7-6438-gc624c86
>
> This is 'journalctl -o short-monotonic -b-4 -k'
>
> https://drive.google.com/open?id=0B_2Asp8DGjJ9ZC1JSDJnaWpnSEE

Btrfs volume 2 is created at [  625.769736]  and mounted at [
640.119150], with the copy starting shortly after that. OOM happens at
[  856.212658] . There are a bunch of earlier bug messages, BUG:
sleeping function called from invalid context at mm/slab.h:393.


-- 
Chris Murphy
