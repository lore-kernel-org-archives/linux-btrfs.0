Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:34136 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753319AbdJCMoj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 08:44:39 -0400
Date: Tue, 3 Oct 2017 17:44:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: btrfs.fredo@xoxy.net, linux-btrfs@vger.kernel.org
Subject: Re: Lost about 3TB
Message-ID: <20171003174437.68e1c8d4@natsu>
In-Reply-To: <20171003105405.GC3293@carfax.org.uk>
References: <134025801.432834337.1507024250294.JavaMail.root@zimbra65-e11.priv.proxad.net>
        <357972705.433103936.1507027469780.JavaMail.root@zimbra65-e11.priv.proxad.net>
        <20171003105405.GC3293@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 3 Oct 2017 10:54:05 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

>    There are other possibilities for missing space, but let's cover
> the obvious ones first.

One more obvious thing would be files that are deleted, but still kept open by
some app (possibly even from network, via NFS or SMB!). @Frederic, did you try
rebooting the system?

-- 
With respect,
Roman
