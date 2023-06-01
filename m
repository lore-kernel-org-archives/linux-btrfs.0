Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC62DC7EE23
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Jun 2023 10:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjFAKzD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjFAKyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2023 06:54:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF35F2
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Jun 2023 03:54:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE8BE68AA6; Thu,  1 Jun 2023 12:54:50 +0200 (CEST)
Date:   Thu, 1 Jun 2023 12:54:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] btrfs: fix dev-replace after the scrub rework
Message-ID: <20230601105450.GA12369@lst.de>
References: <61e46bae045ec4e5173874dc81cb178e456644ab.1685616199.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e46bae045ec4e5173874dc81cb178e456644ab.1685616199.git.wqu@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

