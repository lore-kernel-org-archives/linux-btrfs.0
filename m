Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbeCVNnF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:43:05 -0400
Subject: Re: [PATCH v2] btrfs-progs: wipe stale sb copy beyond -b size
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <85e452b8-f226-426a-dbb4-051313961477@oracle.com>
Date: Thu, 22 Mar 2018 21:44:52 +0800
MIME-Version: 1.0
In-Reply-To: <e4abd1b3-ec4e-ca3c-675e-66b2066757c9@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180322130141.19894-3-anand.jain@oracle.com>
 <e4abd1b3-ec4e-ca3c-675e-66b2066757c9@suse.com>


> 
> I continue asserting that all this code is unnecessary, just wipe every
> sb between 0, dev_size and be done with it.

  Yep. That's a nice clean up. We have tried to use libblkid a long time
  back but there were some issues. So we used the open code.

  As of now there is other bigger concern as I mentioned in the cover
  letter under caveat. Hope they are ok?. If they are ok shall try again
  to use libblkid.

Thanks, Anand
