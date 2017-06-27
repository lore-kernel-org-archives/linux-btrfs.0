Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34681 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752753AbdF0N07 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 09:26:59 -0400
Received: by mail-pf0-f174.google.com with SMTP id s66so16650169pfs.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 06:26:58 -0700 (PDT)
Subject: Re: [PATCH 0/5] v3 block subsystem refcounter conversions
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
Date: Tue, 27 Jun 2017 07:26:55 -0600
MIME-Version: 1.0
In-Reply-To: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2017 05:39 AM, Elena Reshetova wrote:
> Changes in v3:
> No changes in patches apart from trivial rebases, but now by
> default refcount_t = atomic_t and uses all atomic standard operations
> unless CONFIG_REFCOUNT_FULL is enabled. This is a compromize for the
> systems that are critical on performance and cannot accept even
> slight delay on the refcounter operations.

Is that true in 4.12-rc, or is that true in a later release once
Linus has pulled those changes in? If the latter, please resend
this when those changes are in, thanks.

-- 
Jens Axboe

