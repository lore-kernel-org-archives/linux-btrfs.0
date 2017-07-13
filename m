Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44416 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdGMWep (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 18:34:45 -0400
Date: Thu, 13 Jul 2017 15:32:05 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
Message-ID: <20170713223205.GB6181@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 02:49:27PM -0600, Chris Murphy wrote:
> Has anyone been working with Docker and Btrfs + overlayfs? It seems
> superfluous or unnecessary to use overlayfs, but the shared page cache
> aspect and avoiding some of the problems with large numbers of Btrfs
> snapshots, might make it a useful combination. But I'm not finding
> useful information with searches. Typically it's Btrfs alone vs
> ext4/XFS + overlayfs.
> 
> ?

Is there a reproducer for problems with large number of btrfs
snapshots?

Btrfs + overlayfs?  The copy-up coperation in overlayfs can take
advantage of btrfs's clone, but this benefit applies for xfs, too.

thanks,

-liubo
