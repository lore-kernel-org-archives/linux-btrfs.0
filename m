Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCB4C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD41E2077C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfDWLb6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:31:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfDWLb6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 07:31:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AC5FACEF;
        Tue, 23 Apr 2019 11:31:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B4531DA7FC; Tue, 23 Apr 2019 13:33:02 +0200 (CEST)
Date:   Tue, 23 Apr 2019 13:33:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fallocate does not prevent ENOSPC on write
Message-ID: <20190423113302.GS20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
> On 2019/4/23 上午5:09, Jakob Unterwurzacher wrote:
> > I have a user who is reporting ENOSPC errors when running gocryptfs on
> > top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395 ).
> > 
> > What is interesting is that the error gets thrown at write time. This
> > is not supposed to happen, because gocryptfs does
> > 
> >     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
> > 
> > before writing.
> > 
> > I wrote a minimal reproducer in C: https://github.com/rfjakob/fallocate_write
> > This is what it looks like on ext4:
> > 
> >     $ ../fallocate_write/fallocate_write
> >     reading from /dev/urandom
> >     writing to ./blob.379Q8P
> >     writing blocks of 132096 bytes each
> >     [...]
> >     fallocate failed: No space left on device
> > 
> > On btrfs, it will instead look like this:
> > 
> >     [...]
> >     pwrite failed: No space left on device
> > 
> > Is this a bug in btrfs' fallocate implementation or am I reading the
> > guarantees that fallocate gives me wrong?
> 
> Since v4.7, this commit changed the how btrfs do NodataCOW check:
> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
> 
> Before that commit, btrfs always check if they need to reserve space for
> COW, while after that patch, btrfs never checks unless we have no space.
> 
> However this screws up other nodatacow space check.
> And due to its age and deep changeset, it's pretty hard to fix it.
> I have tried several times, but it will only cause more problems.

What if the commit is reverted, if the problem is otherwise hard to fix?
This seems to break the semantics of fallocate so the performance should
not the main concern here.
