Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51379 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751026Ab3G0EWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 00:22:49 -0400
Message-ID: <1374898959.3686.10.camel@joe-AO722>
Subject: Re: [trivial PATCH] treewide: Add __GFP_NOWARN to k.alloc calls
 with v.alloc fallbacks
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Divy Le Ray <divy@chelsio.com>, Dimitris Michailidis <dm@chelsio.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Chris Mason <chris.mason@fusionio.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel <cluster-devel@redhat.com>
Date: Fri, 26 Jul 2013 21:22:39 -0700
In-Reply-To: <1371669353.2038.45.camel@joe-AO722>
References: <1371669353.2038.45.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2013-06-19 at 12:15 -0700, Joe Perches wrote:
> Don't emit OOM warnings when k.alloc calls fail when
> there there is a v.alloc immediately afterwards.
> 
> Converted a kmalloc/vmalloc with memset to kzalloc/vzalloc.

Hey Jiri.

What's your schedule for accepting or rejecting
these sorts of patches?

