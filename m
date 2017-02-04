Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:40448 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbdBDUtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Feb 2017 15:49:35 -0500
Mime-Version: 1.0
Date: Sat, 04 Feb 2017 20:50:03 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <1f5f66cfa8eca19b7e612e3b4745d788@85337f6d4fa4>
From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Very slow balance / btrfs-transaction
To: "Goldwyn Rodrigues" <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
In-Reply-To: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de> wrote:

> Yes, please check if disabling quotas makes a difference in execution
> time of btrfs balance.

Just FYI: With quotas disabled it took ~20h to finish the balance instead of the projected >30 days. Therefore, in my case, there was a speedup of factor ~35.


and thanks for the quick reply! (and for btrfs general!)


BTW: I'm wondering how much sense it makes to activate the underlying bcache for my raid1 fs again. I guess btrfs chooses randomly (or based predicted of disk latency?) which copy of a given extend to load? I guess that would mean the effective cache size would only be half of the actual cache-set size (+-additional overhead)? Or does btrfs try a deterministically determined copy of each extend first? 



   j
