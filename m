Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaBHNHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 08:07:51 -0500
Date: Sat, 8 Feb 2014 21:07:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000038
Message-ID: <20140208130749.GB16468@localhost>
References: <20140207023801.GC11051@localhost>
 <alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com>
 <20140207121038.GA1690@localhost>
 <52F4F755.4090503@fb.com>
 <CAL3q7H6ZRzXqaxF_DQbeiRdE_dy=62BjFHiBKt=YAiGgEeiCRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6ZRzXqaxF_DQbeiRdE_dy=62BjFHiBKt=YAiGgEeiCRA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If you disable CONFIG_BTRFS_FS_RUN_SANITY_TESTS, does it still crash?

Good idea! I've queued test jobs for that config. However sorry that
I'll be offline for the next 2 days. So please expect some delays.

Thanks,
Fengguang
