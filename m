Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751902AbdFOK51 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 06:57:27 -0400
Subject: Re: [PATCH] Btrfs: inode.c convert local flags int -> bool
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170615104801.4949-1-nefelim4ag@gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3d87fed0-639f-ff1e-5d17-780afe57e1b6@suse.com>
Date: Thu, 15 Jun 2017 13:57:19 +0300
MIME-Version: 1.0
In-Reply-To: <20170615104801.4949-1-nefelim4ag@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.06.2017 13:48, Timofey Titovets wrote:
> Just conversion from int to bool where it applicable
> Only change function local flags to not break external
> function / structures
> 
> Reasons:
> 1. Separate variables like:
>    - ret = 1 - ret value with special handling from caller
>    - insert = 1 - three-state flag
>    - reserve = 1 - just a flag
>    - reserved = 0 - just a flag
>    - scanned = 0 - counter
> 2. Sync usage of bool for flags with other code
> for decrease blending int/bool
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
While I myself am a fan of bool and hate it when people use an int to
signify a boolean variable patches such as this one create needless
churn. If you have a fix, or a major refactoring to contribute and you
can also manage to squeeze in such a fixup then yes, but this - no.
