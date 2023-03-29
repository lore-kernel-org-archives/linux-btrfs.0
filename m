Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5306DC6FD18
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Mar 2023 23:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjC2Xdy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 19:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjC2Xdw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2023 19:33:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5866C4C13
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Mar 2023 16:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Z6wSBd48vv2VIFFt0R0zF1TCIICedYZkNStdQDWmZGk=; b=KpJHy/P4BPYXaYpIPzUSb/n+QS
        7I1NZ0QsbtI6nsOpdjRHYlUmB1lYBvVtg4hNI/HgJWcOudIIm+GR24JWITzDaTsonLYhLFFwL9+lx
        Gtk4p0JGR0gQdjlEfXrV0Re+y5NI3eMaxi5xxXp271qNFKhm/b1rCVXIfG6FE8Cnj7TTfI2smhgEJ
        Wr/SD6WpCq4ifHPUh2m1Y5/qaUGAW16O25c0bPjRAsgMMKDhvXrJ3m4N+crbi7FKssrNQEqkjVIw3
        4r6vXVRnw/vbgW8bt7JSkBLJLuw0r8nG8uazuL2+fwupZ33dMjVfCJOmKuNWUDJq+8g777fSTJGF0
        XTJfjOLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1phfId-0024PI-0E;
        Wed, 29 Mar 2023 23:33:51 +0000
Date:   Wed, 29 Mar 2023 16:33:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v7 04/13] btrfs: introduce a new helper to submit write
 bio for scrub
Message-ID: <ZCTK34vrpfGiCu1B@infradead.org>
References: <cover.1680047473.git.wqu@suse.com>
 <72f4fa26c35f2e649bc562a80a40955d745f1118.1680047473.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72f4fa26c35f2e649bc562a80a40955d745f1118.1680047473.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Same here, hadn't we just decided to share code with
ⅺtrfs_repair_io_failure?

