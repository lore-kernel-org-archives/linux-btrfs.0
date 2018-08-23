Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:36524 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbeHWNuD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 09:50:03 -0400
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <a7c9a5e4-8c14-a499-cf07-bb5acb4b9dd8@applied-asynchrony.com>
Date: Thu, 23 Aug 2018 12:21:00 +0200
MIME-Version: 1.0
In-Reply-To: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/22/18 21:51, Liu Bo wrote:
> Several structs in btrfs are using rb_first() in a while loop, it'd be
> more efficient to do this with rb_first_cached() which has the O(1)
> complexity.
> 
> This patch set updates five structs which may have a large rb tree in
> practice

Great idea, works for me with no bad side effects so far. So:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers
Holger
