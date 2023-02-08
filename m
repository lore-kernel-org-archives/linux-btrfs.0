Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9759CC636D3
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Feb 2023 20:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjBHUhB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 15:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjBHUhA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2023 15:37:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8422976F
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Feb 2023 12:36:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6FB9934611;
        Wed,  8 Feb 2023 20:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675888617;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oP0oc8NbQ+04tzPXUNB18oY78JMcDCnDpnnWg695oSM=;
        b=Edh2kUq/EKHGRl58wywgyeScg09jWh6wE2HT8vpZOPYi20PyzDqW/PaoZgel4qnmWHgU8s
        y8VB7ZRX7cEjA2/t9wW0ZGX5o5JlSgw4HRFQCGgLvvYnZZ7K/mjxr5ryvYAprjTzayEz2H
        Q014kjnNV07CrzhRXffIvJU5HIK0TTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675888617;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oP0oc8NbQ+04tzPXUNB18oY78JMcDCnDpnnWg695oSM=;
        b=Mz4uvtdTg2dRLYLQLxljJeoDW+XdYjNHZoXJ6TQMzmrLwX16vgdP4sDNx6Mv5UbT0Zbah0
        p/5RoQmxMsA9DRBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D3951358A;
        Wed,  8 Feb 2023 20:36:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jnyxEekH5GPsMgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 08 Feb 2023 20:36:57 +0000
Date:   Wed, 8 Feb 2023 21:31:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: lock the inode in shared mode before starting
 fiemap
Message-ID: <20230208203108.GL28288@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5c6c1cefa7df5fbe9c4dc2fe517f521760a2f4be.1674492773.git.fdmanana@suse.com>
 <20230207154021.GG28288@twin.jikos.cz>
 <CAL3q7H52v9xo856Tp5g61a2ah=7FPvaOPeQ_cR18cB63f6tWHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H52v9xo856Tp5g61a2ah=7FPvaOPeQ_cR18cB63f6tWHQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 07, 2023 at 04:15:00PM +0000, Filipe Manana wrote:
> On Tue, Feb 7, 2023 at 3:46 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Mon, Jan 23, 2023 at 04:54:46PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> >
> > > Fix this by taking the inode's lock (VFS lock) in shared mode when
> > > entering fiemap. This effectively serializes fiemap with fsync (except the
> > > most expensive part of fsync, the log sync), preventing this deadlock.
> >
> > Could this be a problem, when a continuous fiemap would block fsync on a
> > file? Fsync is more important and I'd give it priority when the inode
> > lock is contended, fiemap is only informative and best effort. The
> > deadlock needs to be fixed of course but some mechanism should be in
> > place to favor other lock holders than fiemap. Quick idea is to relock
> > after each say 100 extents.
> 
> Typically fiemap is called with a small buffer for extent entries. cp
> and filefrag for example use a small buffer.
> So they repeatedly call fiemap with such a small buffer (not more than
> a 100 or 200 entries).

I see, so the buffer size can limit that naturally.

> Do you think it's that common to have fiemap and fsync attempts in parallel?
> 
> I don't think it's a problem, not only it shouldn't be common, but if
> it happens it's for a very short time. Even for a very long fiemap
> buffer.

Yeah it's not supposed to be common, I was thinking about the corner
case. The worst case is when several parallel fiemaps are running that
don't relinquish the inode lock and another thread writes+fsyncs the
file and stalls. Imagine use case like a monitoring tool for VM images
that watches used space due to thin provisioning and eg. qemu that uses
the image file. The fix is to do fiemap in small chunks as said above.
