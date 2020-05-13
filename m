Return-Path: <SRS0=9t/X=63=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262F1C2D0FC
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 00:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086482078C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 May 2020 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589330980;
	bh=5xxEuhqwQ1ZoTeMzuFWoOFfxthfBb2bik4Tj6f2A94U=;
	h=Date:From:To:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=hksQYEEhvI5X3Zd62v6mAHSLicHvrbSz5AsaVoVEgfOQyH3OYBmCTkN8vHR2Z4n6B
	 YxhjfhG+vlLFwQhlCUsB7VS9zYqDbDrQXcwosH6KtTczeqp+sffLTWl05ff4bcSCSd
	 ldpVwe9iaQw9xYyT3xGYOw84HzDSGb8bG1gz1GjQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgEMAtj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 May 2020 20:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgEMAtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 May 2020 20:49:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C841820675;
        Wed, 13 May 2020 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589330979;
        bh=5xxEuhqwQ1ZoTeMzuFWoOFfxthfBb2bik4Tj6f2A94U=;
        h=Date:From:To:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:
         From;
        b=mXGpcXKm/2jHUhIZXYtstKAwILNMj4dpqdMhidkiN8DEITRe7XvM7MZkG/3qbvAX8
         R/hqIm//X1+ANZdNK85A+aeKRn8VuwrxMuPNEFaMNZ0vbmt2w85PGv3kTMPj419ZwE
         niDINvDmgUGI6X+bzhPjkEXKe2CUETw3DplzMi4E=
Date:   Wed, 13 May 2020 00:49:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
To:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: send: Emit file capabilities after chown
In-Reply-To: <20200511021507.26942-1-marcos@mpdesouza.com>
References: <20200511021507.26942-1-marcos@mpdesouza.com>
Message-Id: <20200513004938.C841820675@mail.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Build OK!
v4.14.179: Build OK!
v4.9.222: Build OK!
v4.4.222: Failed to apply! Possible dependencies:
    1ec9a1ae1e30 ("Btrfs: fix unreplayable log after snapshot delete + parent dir fsync")
    ebb8765b2ded ("btrfs: move btrfs_compression_type to compression.h")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
