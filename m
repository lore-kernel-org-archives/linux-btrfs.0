Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7EFC31E57
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 13:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC002082C
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 13:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFQNRu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:17:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:55902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbfFQNRu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 09:17:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E245CAE87;
        Mon, 17 Jun 2019 13:17:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7C970DA8D1; Mon, 17 Jun 2019 15:18:37 +0200 (CEST)
Date:   Mon, 17 Jun 2019 15:18:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Proper packed attribute usage?
Message-ID: <20190617131837.GE19057@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <f24ea8b6-01ff-f570-4b9b-43b4126118e6@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24ea8b6-01ff-f570-4b9b-43b4126118e6@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 17, 2019 at 05:06:22PM +0800, Qu Wenruo wrote:
> And for a btrfs specific question, why we have packed attribute for
> btrfs_key?
> I see no specific reason to make a CPU native structure packed, not to
> mention we already have btrfs_disk_key.

For that one there's no reason to use packed and we can go further and
reorder the members so that the offset is right after objectid, ie. both
at aligned addresses.  I have a patch for that but I still need to
validate that.
