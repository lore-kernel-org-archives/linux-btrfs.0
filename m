Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45545 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbeIDWYJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 18:24:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id z125-v6so3016583qkb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 10:57:58 -0700 (PDT)
Date: Tue, 4 Sep 2018 13:57:56 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/35] btrfs: add ALLOC_CHUNK_FORCE to the flushing code
Message-ID: <20180904175755.3wyvm6psdsjgom4k@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-13-josef@toxicpanda.com>
 <c7905ccc-ba8c-fe9d-e6b7-fa44443a8984@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c7905ccc-ba8c-fe9d-e6b7-fa44443a8984@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 05:19:19PM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > +		if (flush_state == ALLOC_CHUNK_FORCE && !commit_cycles)
> > +			flush_state++;
> 
> This is a bit obscure. So if we allocated a chunk and !commit_cycles
> just break from the loop? What's the reasoning behind this ?

I'll add a comment, but it doesn't break the loop, it just goes to COMMIT_TRANS.
The idea is we don't want to force a chunk allocation if we're experiencing a
little bit of pressure, because we could end up with a drive full of empty
metadata chunks.  We want to try committing the transaction first, and then if
we still have issues we can force a chunk allocation.  Thanks,

Josef
