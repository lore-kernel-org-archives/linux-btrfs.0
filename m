Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38210 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcHHOV7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 10:21:59 -0400
Received: by mail-wm0-f44.google.com with SMTP id o80so142579334wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 07:21:58 -0700 (PDT)
Subject: Re: Crash in btrfs_uuid_tree_iterate during mount
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
References: <57A473B0.2040203@kyup.com>
 <657b7978-1d08-f052-8ebc-f061ecb542d0@fb.com> <57A863C6.5060503@kyup.com>
 <ce59ace9-9cf3-ec8e-1f25-d6b794cf5109@fb.com>
Cc: SiteGround Operations <operations@siteground.com>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <57A89583.6070600@kyup.com>
Date: Mon, 8 Aug 2016 17:21:55 +0300
MIME-Version: 1.0
In-Reply-To: <ce59ace9-9cf3-ec8e-1f25-d6b794cf5109@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/08/2016 05:16 PM, Chris Mason wrote:
> 
> Fantastic, thanks again for digging through it.  Making the patch is
> much easier than testing the patch in this case.  If you can trigger
> this semi-reliably, we can add some debugging to make sure we're not
> papering over some other problem.

I don;'t have a reproducer per-se, but I have a fair number of servers,
whose workload causes the issue, so if I patch btrfs and apply it to
5-10 server I;d expect at least one of them to show what the real issue is.
