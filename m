Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DA4C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45A91206B7
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547473931;
	bh=q6wULXGR31/5T5zFPPEA2IWr3p87lk3w+qzDj1Ft27E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=f4DrQfCBJf3Wi/59UsADgCXlVfOM0TGj7jpJQ/noAP0EsFfx+r8sOyKmi787hdLTL
	 /q/qircX1yRF3+YGqWt+BrEFJFRl7p8sDwbQfTHDqH2T4mwAePJNwGYeyNACm/6UHr
	 CGa9uffqGl5mEnIscaHXM5PffFFmEs6aizYgxhLQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfANNwK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfANNwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:52:09 -0500
Received: from localhost (unknown [178.227.249.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1373208E4;
        Mon, 14 Jan 2019 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547473929;
        bh=q6wULXGR31/5T5zFPPEA2IWr3p87lk3w+qzDj1Ft27E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hGtKafMsV3loBM4t8sbTpLz1bbielnOgAZluomHawhrttZe4PHR50laqYyw9+R7YV
         rXRUHLI9bfP5DTgLRYTPfpN0TG2UU/b/oEmZ1iZLAygnFfQnXggMh9Fs1rd15aX1zY
         3wveq4W9fEmcNLqQHYLDBjQpOI7BhP/qpOVGjsXc=
Date:   Mon, 14 Jan 2019 14:50:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: Security fixes for 4.4 - btrfs
Message-ID: <20190114135052.GA11079@kroah.com>
References: <1547218151.3229.73.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547218151.3229.73.camel@codethink.co.uk>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 11, 2019 at 02:49:11PM +0000, Ben Hutchings wrote:
> I've backported fixes for several security issues involving filesystem
> validation in btrfs.  All of these are already fixed in the later
> stable branches.
> 
> I tested with the reproducers where available.  I also checked for
> regressions with xfstests and didn't find any (but many tests fail with
> or without these changes).

Many thanks for all of these, now queued up.

greg k-h
