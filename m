Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:34733 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933953AbeAXPix (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 10:38:53 -0500
Received: by mail-qt0-f175.google.com with SMTP id a27so11358681qtd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 07:38:52 -0800 (PST)
Date: Wed, 24 Jan 2018 10:38:51 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use schedule_timeout_interruptible
Message-ID: <20180124153850.4qhg32efy73x5cfj@destiny>
References: <1516711613-18533-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1516711613-18533-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 02:46:53PM +0200, Nikolay Borisov wrote:
> Instead of manually fiddling with the state of the task
> (RUNNING->INTERRUPTIBLE->RUNNING) again just use schedule_timeout_interruptible
> which adjusts the task state as needed. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
