Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48729 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031623AbdDTN4z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 09:56:55 -0400
Date: Thu, 20 Apr 2017 06:56:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH 0/5] v2: block subsystem refcounter conversions
Message-ID: <20170420135651.GA26595@infradead.org>
References: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492687644-4405-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


All the objections from DaveM on the amount of cycles spent on the
new refcount_t apply to the block layer fast path operations as well.

Please don't send any more conversions until those have been resolved.
