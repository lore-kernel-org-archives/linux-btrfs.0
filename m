Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE05C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29AC821B68
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbfBKSoD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:44:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:56420 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbfBKSoD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 13:44:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1993BB136;
        Mon, 11 Feb 2019 18:44:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53AF1DA84E; Mon, 11 Feb 2019 19:43:23 +0100 (CET)
Date:   Mon, 11 Feb 2019 19:43:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: reorg functions to drop forward declaration
Message-ID: <20190211184323.GZ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
 <1549609355-11053-4-git-send-email-anand.jain@oracle.com>
 <4625b575-8599-00f2-3334-1789b6718d66@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4625b575-8599-00f2-3334-1789b6718d66@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 08, 2019 at 09:10:41AM +0200, Nikolay Borisov wrote:
> 
> 
> On 8.02.19 г. 9:02 ч., Anand Jain wrote:
> > In preparation to drop forward declaration of the functions,
> > prop_compression_validate(), prop_compression_apply() and
> > prop_compression_extract(). Move prop_handlers[], btrfs_props_init()
> > prop_compression_validate(), prop_compression_apply() and
> > prop_compression_extract() appropriately with in the file. No functional
> > changes.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> I'm fine with this, however I think this and the next patch could really
> be squashed into one, but let's see what David prefers.

I agree, moving the functions in order remove the prototypes in one
patch is fine.
