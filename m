Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0E2C25B0C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Aug 2022 13:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243350AbiHHNj0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 09:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243352AbiHHNjY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2022 09:39:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE5BE14;
        Mon,  8 Aug 2022 06:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A487B80A07;
        Mon,  8 Aug 2022 13:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D9CC433D6;
        Mon,  8 Aug 2022 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659965961;
        bh=EGTLK5CK+0YFCQyRoE34Uqe6ojLcJp8SAYh0AhOP8Nc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuugYBPFQDESdKKb/3tfKUpsfmfyIEjCZbi3j6DN55LFEXx5pXPUq4OtY9gSEq40z
         VjhHzJnABJ6JUZYE9+hlbiHE8HMg3GXRW/pf0x9Nxe9OtDNmlMqMIBoAz1hMTabt/L
         Wp2S8SRixBdN1EJOn5RYKwb85KsxZPoJvZbpndyA=
Date:   Mon, 8 Aug 2022 15:39:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Message-ID: <YvESBmvjMqIXvqjp@kroah.com>
References: <cover.1659600630.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1659600630.git.wqu@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 04, 2022 at 04:10:57PM +0800, Qu Wenruo wrote:
> Hi Greg and Sasha,
> 
> This two patches are backports for v5.18 branch.

I also need these for the 5.19.y branch if we were to take them into
5.18.y as you do not want anyone to suffer a regression when moving to
the newer kernel release.

So I'll wait for those to be sent before taking any of these.

thanks,

greg k-h
