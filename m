Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DEBC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 17:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D2532087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 17:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfCYRCv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 13:02:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729106AbfCYRCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 13:02:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 000AAAF17;
        Mon, 25 Mar 2019 17:02:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11916DA98F; Mon, 25 Mar 2019 18:04:01 +0100 (CET)
Date:   Mon, 25 Mar 2019 18:04:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 5/9] btrfs: tree-checker: Verify dev item
Message-ID: <20190325170401.GN10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-6-wqu@suse.com>
 <1472c094-bc6a-dc6f-2cf8-220ad5d34e40@suse.de>
 <b6c74880-ddca-8772-41f2-a3b1587e8374@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c74880-ddca-8772-41f2-a3b1587e8374@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 07:53:18PM +0800, Qu Wenruo wrote:
> >> +error:
> >> +	return -EUCLEAN;
> >> +}
> >> +
> > 
> > Why aren't you directly returning -EUCLEAN instead of the gotos? There's
> > no cleanup pending so the additional jump label is unnecessary.
> 
> Just a coding preference.
> 
> Will it impact the performance or compiler is clever enough to change
> the goto line to return -EUCLEAN?

This is a matter of codingstyle, it should be consistent, so if one
function uses return -EUCLEAN and another goto error:, then one of them
has to be changed.
