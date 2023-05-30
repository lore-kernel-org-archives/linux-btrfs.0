Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789BAC7EE23
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 May 2023 14:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjE3O1e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 May 2023 10:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbjE3O1O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2023 10:27:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411DD125
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2023 07:26:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0483968B05; Tue, 30 May 2023 16:26:03 +0200 (CEST)
Date:   Tue, 30 May 2023 16:26:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 08/16] btrfs: stop setting PageError in the data I/O
 path
Message-ID: <20230530142602.GC9014@lst.de>
References: <20230523081322.331337-1-hch@lst.de> <20230523081322.331337-9-hch@lst.de> <20230529175210.GL575@twin.jikos.cz> <20230530054547.GA5825@lst.de> <ZHWS5nOm++6zCNkE@casper.infradead.org> <20230530133446.GR575@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530133446.GR575@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 30, 2023 at 03:34:46PM +0200, David Sterba wrote:
> I found one case of folio_set_error() that seems to be redundant:

Ooops, I missed that as it's one of the few folio based things in
btrfs.  I'll fix it up together with the other little things in a
resend.

