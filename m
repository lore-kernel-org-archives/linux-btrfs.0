Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0218BC433EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 May 2022 10:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379495AbiEMKeE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 May 2022 06:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379445AbiEMKeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 May 2022 06:34:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2E51A8DCA
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2022 03:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oVZ039+PqjhPfoo4OokfN5igQXvetYMX/b2k/CsUTco=; b=1D1ZQUovHP/XP76730DzLHsZRm
        CzOCBlWjB3nFbf2DhXKt8xB6cPypA69TzvjtdqsVawsUKe8GOLkIfJ8gMH774WhTiM7O9q8jNGBMU
        d0dDUZ2bJH0ChBYaeQk861vd6hf9quaEn4f5Fla/5OEO+RYqSn3mf/iLfeD6fWZicqxlheZTfTGYl
        TrG6IctmW/8tXdN1I/1gTWLtnAfi/5BvfLKGiEl1JAREPQrWW4WGM0bjqx0RGVr6vehyKArKNaRvt
        igKcDN0fQbWIK0rflfh61whH3VZcIBXhmElUMR7yM8TdAchQL8XZbBpWb3LznMALcjkghjEHZKnXA
        7IGdpCcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npScQ-00FagE-UL; Fri, 13 May 2022 10:33:58 +0000
Date:   Fri, 13 May 2022 03:33:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Christoph Hellwig <hch@infradead.org>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/13] btrfs: add btrfs_read_repair_ctrl to record
 corrupted sectors
Message-ID: <Yn40Fkhz0jyef1ow@infradead.org>
References: <cover.1651559986.git.wqu@suse.com>
 <3f9b82f1bcc955fbb689a469e749cf1534857ea1.1651559986.git.wqu@suse.com>
 <YnFE62oGR5C/8UN2@infradead.org>
 <dac4707a-04f4-f143-342b-cd69e0ffcd80@gmx.com>
 <YnKIM/KBIJEqU/6b@infradead.org>
 <efb8bdf0-28f0-0db9-c2b0-a08ffbd22623@gmx.com>
 <20220512171629.GT18596@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512171629.GT18596@twin.jikos.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

FYI, I have a new different approach for the repair code that doesn't
need any bitmap at all.  Should be ready to post in the next days.
