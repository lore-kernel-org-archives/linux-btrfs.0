Return-Path: <SRS0=o+mG=3Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FDEC352A2
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 14:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB89922464
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580913908;
	bh=94GkFpBxAel3ql0NTweeMe/aQbZ1pXa5A68amsyF/dI=;
	h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:List-ID:
	 From;
	b=KYzZ8jcBhZBNuVy/j9atG+V7NnG5iJF8kcpPghfHH/+bQnzpIxaMEmoO9nN17ojwY
	 v95I7lo1Qwi/6wrkVTiL3pJ6u5e7PVGXbzJY3udDIc5OzxjOQQoU9R6LXCiITM+lU1
	 x3JN7U7cCcDH0BLVsR+La2pzlnTQ3l/+64mZsmV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBEOpI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 09:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgBEOpH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Feb 2020 09:45:07 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F5F218AC;
        Wed,  5 Feb 2020 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580913907;
        bh=94GkFpBxAel3ql0NTweeMe/aQbZ1pXa5A68amsyF/dI=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=EUsbTdUHALsNvSgloGkVsnike7amrg5DZDnAKzKroS2IRP9EaoIo+GpzX2c5bDuc8
         vV1jE2oOC/MQx5CMCa4h0KHMb1x5TZl+vMGKxuR5kpKtJ4sqdBPoTtfhZC1HFjayN4
         QKLV2ozcGJwgbWYqgKy5Wgxj5JbJCksQThc2BGWk=
Date:   Wed, 05 Feb 2020 14:45:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between using extent maps and merging them
In-Reply-To: <20200131140607.26923-1-fdmanana@kernel.org>
References: <20200131140607.26923-1-fdmanana@kernel.org>
Message-Id: <20200205144507.31F5F218AC@mail.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.5.1, v5.4.17, v4.19.101, v4.14.169, v4.9.212, v4.4.212.

v5.5.1: Build OK!
v5.4.17: Build OK!
v4.19.101: Build OK!
v4.14.169: Build OK!
v4.9.212: Build failed! Errors:
    fs/btrfs/extent_map.c:238:6: error: implicit declaration of function ‘refcount_read’ [-Werror=implicit-function-declaration]

v4.4.212: Build failed! Errors:
    fs/btrfs/extent_map.c:238:6: error: implicit declaration of function ‘refcount_read’ [-Werror=implicit-function-declaration]


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
