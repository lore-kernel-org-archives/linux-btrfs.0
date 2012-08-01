Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38871 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2HAMOo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:14:44 -0400
Received: by pbbrp8 with SMTP id rp8so1014456pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 05:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
Date: Wed, 1 Aug 2012 14:14:44 +0200
Message-ID: <CAB9VWqCcNhUVX3CsZeCar07TYr2hXuw+-A_wDbb4uNstLr_9Fg@mail.gmail.com>
Subject: Re: [PATCH] add crtime to the snapshot list
From: Alexander Block <ablock84@googlemail.com>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 1, 2012 at 2:01 PM, Anand jain <Anand.Jain@oracle.com> wrote:
> From: Anand <anand.jain@oracle.com>
>
>  This patch adds creation-time to the snapshot list display,
>  which would help user to better manage the snapshots when
>  number of snapshots grow substantially. This patch is developed
>  and on top of the send/receive btrfs and btrfs-progs repo at
>   git://github.com/ablock84/linux-btrfs.git (send-v2)
>   git://github.com/ablock84/btrfs-progs.git (send-v2)
>  respectively.
>
Cool, that would helpful.
>  Further this patch has the dependency on the following patches
>   Liu Bo:
>    [PATCH 2/3 RESEND] Btrfs-progs: show generation in command btrfs subvol list
>    [PATCH 3/3] Btrfs-progs: list snapshots by generation
>
>  Eg output:
>    #btrfs su list -s 1 /btrfs
>    ID 258 gen 39 cgen 6 top level 5 crtime 2012-07-27 17:43:55 path ss1
>    ID 260 gen 8 cgen 8 top level 5 crtime 2012-07-27 17:47:51 path ss2
>    ID 263 gen 16 cgen 16 top level 5 crtime 2012-07-29 00:50:19 path ss3
>    ID 264 gen 25 cgen 25 top level 5 crtime 2012-07-30 09:56:50 path sv1/.snap
Is it possible to rename crtime to otime? I used otime to refer
creation time all the time. Using crtime could be confusing, as ctime
is the change time and rtime is the receive time.
>
> Anand Jain (1):
>   Btrfs-progs: show crtime in the snapshot list
>
>  btrfs-list.c |   45 ++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 36 insertions(+), 9 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
