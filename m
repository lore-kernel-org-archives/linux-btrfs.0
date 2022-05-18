Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26F7C433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 May 2022 08:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiERIon (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 May 2022 04:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiERIom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 May 2022 04:44:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51E15C36B
        for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2022 01:44:40 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 33DCF68AFE; Wed, 18 May 2022 10:44:38 +0200 (CEST)
Date:   Wed, 18 May 2022 10:44:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 01/15] btrfs: introduce a pure data checksum checking
 helper
Message-ID: <20220518084437.GB6933@lst.de>
References: <20220517145039.3202184-1-hch@lst.de> <20220517145039.3202184-2-hch@lst.de> <PH0PR04MB74168E42A977889B254953D29BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74168E42A977889B254953D29BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 17, 2022 at 02:59:13PM +0000, Johannes Thumshirn wrote:
> This makes the read flow a bit awkward IMHO, as it returns in the middle of the
> function with the "good" condition and then continues with error handling.
> 
> How about:
> 
> 	if (btrfs_check_data_sector(...))
> 		goto zeroit;
> 
> 	return 0;
> 
> zeroit:
> 	btrfs_print_data_csum_error(...);

Well, the flow was just as a bad before, but otherwise I agree.
