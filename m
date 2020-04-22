Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547B2C55186
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 09:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F8720774
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 09:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="jeZ0WTTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDVJdn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 05:33:43 -0400
Received: from mail.nic.cz ([217.31.204.67]:48330 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVJdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 05:33:43 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id B6FE514088B;
        Wed, 22 Apr 2020 11:33:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587548021; bh=jpZUacI/skFibwkwrgjZjyr2c6I2G5qlSKhqtPZC/M4=;
        h=Date:From:To;
        b=jeZ0WTTzJRJQnhgHocmak8hv+OT56bowGSQs6KzPwMQbU33CgEDW8SqDxUOXRidEI
         A5DDsfbBBXWdzDNpZX4x5irTx7cYt5d6GKTzUIG9w1dQyRFAByc4iTldEiiOvM4KUq
         0dIH9yzT4M52L0FDhS5sQZ4uMKqRsojW50JF7OOk=
Date:   Wed, 22 Apr 2020 11:33:41 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 00/26] fs: btrfs: Re-implement btrfs support
 using the more widely used extent buffer base code
Message-ID: <20200422113341.62880c72@nic.cz>
In-Reply-To: <fa3177ef-c264-2fc0-4793-d35209d05d2b@gmx.com>
References: <20200422065009.69392-1-wqu@suse.com>
        <20200422094607.1797ce2e@nic.cz>
        <fa3177ef-c264-2fc0-4793-d35209d05d2b@gmx.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 22 Apr 2020 15:52:25 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> > do you think maybe btrfs-progs / kernel would be interested if I
> > tried to convert their code to this "simpler to use" implementation of
> > conversion functions?  
> 
> I don't think so, the problem is kernel and btrfs-progs all need to
> modify extent buffer, which make the read time conversion become a
> burden in write path.

:(
