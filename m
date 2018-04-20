Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754015AbeDTHeK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 03:34:10 -0400
Subject: Re: [PATCH v2 07/16] btrfs: add proper safety check before resuming
 dev-replace
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <4ebe1fce5a33a3698619e58912418f53b121a131.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <dee31674-f94c-e019-34a9-f9f390904bf2@oracle.com>
Date: Fri, 20 Apr 2018 15:36:18 +0800
MIME-Version: 1.0
In-Reply-To: <4ebe1fce5a33a3698619e58912418f53b121a131.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> The device replace is paused by unmount or read only remount, and
> resumed on next mount or write remount.
> 
> The exclusive status should be checked properly as it's a global
> invariant and we must not allow 2 operations run. In this case, the
> balance can be also paused and resumed under same conditions. It's
> always checked first so dev-replace could see the EXCL_OP already taken,
> BUT, the ioctl would never let start both at the same time.
> 
> Replace the WARN_ON with message and return 0, indicating no error as
> this is purely theoretical and the user will be informed. Resolving that
> manually should be possible by waiting for the other operation to finish
> or cancel the paused state.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

