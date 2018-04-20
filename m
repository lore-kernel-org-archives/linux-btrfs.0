Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753483AbeDTHHT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 03:07:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36C9DADD3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 07:07:18 +0000 (UTC)
Subject: Re: [PATCH v2 09/16] btrfs: cleanup helpers that reset balance state
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <aa843182-8cd9-448e-ccfb-1ec1b95e032f@suse.com>
Date: Fri, 20 Apr 2018 10:07:17 +0300
MIME-Version: 1.0
In-Reply-To: <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.04.2018 19:33, David Sterba wrote:
> +		/* reset_balance_state needs volume_mutex */

Does it make sense to codify this invariant as lockdep_assert_held in
reset_balance_state ?
