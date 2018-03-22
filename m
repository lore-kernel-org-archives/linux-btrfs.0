Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755070AbeCVNfg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:35:36 -0400
Subject: Re: [PATCH v2] btrfs: check if the fsid in the primary sb and copy sb
 are same
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180322130141.19894-1-anand.jain@oracle.com>
 <20180322130141.19894-2-anand.jain@oracle.com>
 <c94f946d-1447-8644-b6e3-49f7a27d16d3@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <fe3a4c3b-ffd0-a39f-6255-7b17b6b0e32e@oracle.com>
Date: Thu, 22 Mar 2018 21:37:23 +0800
MIME-Version: 1.0
In-Reply-To: <c94f946d-1447-8644-b6e3-49f7a27d16d3@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> So the code per-se makes sense. However, have you came across such a
> case in the real world or are you just fixing a theoretical (but real)
> issue?

As discussed in the other thread, the SB csum check is coming to scan
context as well. Now the question I have is, what do we do if the csum
doesn't match, in the inital version we can fail the mount, but in the
long run potentially we could recover it from the good copy.
So if we have to recover it from the good copy we have to ensure copies
are really copies of the primary SB.

Thanks, Anand

