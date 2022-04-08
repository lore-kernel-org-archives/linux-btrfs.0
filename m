Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB33C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Apr 2022 16:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiDHQnJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiDHQnH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2022 12:43:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27AA120B8
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Apr 2022 09:41:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5266068AFE; Fri,  8 Apr 2022 18:41:01 +0200 (CEST)
Date:   Fri, 8 Apr 2022 18:41:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: btrfs zoned fixlets
Message-ID: <20220408164101.GB31302@lst.de>
References: <20220324165210.1586851-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324165210.1586851-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David, 

do you plan to pick these up?
