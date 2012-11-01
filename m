Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41352 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2KAOFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 10:05:06 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1862154lag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 07:05:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121101112114.GA4328@liubo.cn.oracle.com>
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
	<CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com>
	<50911FC0.4080104@oracle.com>
	<CANW9uyse7bw1+=GkV-aRQbDPh1E-t3G4VwkAGc5-76KMfYMjog@mail.gmail.com>
	<20121101112114.GA4328@liubo.cn.oracle.com>
Date: Thu, 1 Nov 2012 23:05:04 +0900
Message-ID: <CANW9uysHg6qk4zSh_yFgP5e545kJZVoma36Hpd1Zzg-hoSVAhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liubo:

The V4 leaves only warnings from btrfs_destroy_inode(). So, you think
it's normal
an "old" extent recorded can be removed from the extent tree by the time
relink_file_extents() invoked?

Itaru

On Thu, Nov 1, 2012 at 8:21 PM, Liu Bo <bo.li.liu@oracle.com> wrote:

> The current btrfs-next HEAD actually have included this v4 patch, so
> just pull btrfs-next and give it a shot :)
>
> thanks,
> liubo
