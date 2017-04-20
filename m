Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:36822 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033109AbdDTQKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 12:10:21 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "james.bottomley@hansenpartnership.com"
        <james.bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "mingo@redhat.com" <mingo@redhat.com>, "clm@fb.com" <clm@fb.com>,
        "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
Subject: RE: [PATCH 0/5] v2: block subsystem refcounter conversions
Date: Thu, 20 Apr 2017 16:10:16 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C8DA36@IRSMSX102.ger.corp.intel.com>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
 <20170420135651.GA26595@infradead.org>
In-Reply-To: <20170420135651.GA26595@infradead.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> All the objections from DaveM on the amount of cycles spent on the
> new refcount_t apply to the block layer fast path operations as well.

Ok, could you please indicate the correct way to measure the impact for the block layer? 
We can do the measurements. 

Best Regards,
Elena.

> 
> Please don't send any more conversions until those have been resolved.
