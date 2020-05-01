Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B851C4724C
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372022064A
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588313019;
	bh=k8psV6XeOjsJuTslwpEw8SYz6ivz1D84bvQwQc/Dkr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pyAUtA7/yuHPN0KZY5+SAZzPwkM4RdOE9p/iTBobv4Acno0vETNNOsSHPcTFR8LTt
	 laTRCWb0QIWv8RYtE0Sn+JFEwD1KOwMaOzMFZMmHs+ZNFjETPg1oT/emIrR1MgEcq6
	 /RndqAOguMSDYJvhFVgO4zyD+gpYfes2+TbHXcEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgEAGDi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgEAGDi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 02:03:38 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C63772063A;
        Fri,  1 May 2020 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588313018;
        bh=k8psV6XeOjsJuTslwpEw8SYz6ivz1D84bvQwQc/Dkr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aX/XfHCwa7+qfTfoWePTAc+M7d4GAp1b0+X06ZEEcJZQxDC6T+PEwODmnyaeDmkX1
         NLTvz34ABMGcMr2ohiwiVjgJEqbCI13AnU2Xt0oHWbOUhgML9vU6HhRexiwBBBopMa
         zn4Ewbz5TKAxbB2SCwZf/ZEcqFoVYpJ8Fo4nk2LU=
Date:   Thu, 30 Apr 2020 23:03:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2 0/2] Add file-system authentication to BTRFS
Message-ID: <20200501060336.GD1003@sol.localdomain>
References: <20200428105859.4719-1-jth@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428105859.4719-1-jth@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 28, 2020 at 12:58:57PM +0200, Johannes Thumshirn wrote:
> 
> There was interest in also using a HMAC version of Blake2b from the community,
> but as none of the crypto libraries used by user-space BTRFS tools as a
> backend does currently implement a HMAC version with Blake2b, it is not (yet)
> included.

Note that BLAKE2b optionally takes a key, so using HMAC with it is unnecessary.

And the kernel crypto API's implementation of BLAKE2b already supports this.
I.e. you can call crypto_shash_setkey() directly on "blake2b-256".

- Eric
