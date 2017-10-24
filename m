Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751865AbdJXKrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:47:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D14FADF8
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Oct 2017 10:47:13 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: What is the purpose of EXTENT_PAGE_MAPPED
Message-ID: <f8f92f68-7ea9-e08e-bb4c-602616d46813@suse.de>
Date: Tue, 24 Oct 2017 05:47:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


EXTENT_PAGE_MAPPED gets set in set_page_extent_mapped(), but I don't see
it being cross checked anytime. What is the purpose of setting it?

-- 
Goldwyn
