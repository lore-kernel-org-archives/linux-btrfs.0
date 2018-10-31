Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F67C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 15:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C342080A
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 15:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65C342080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbeKAAns (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 20:43:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:49552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeKAAns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 20:43:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 27744B060;
        Wed, 31 Oct 2018 15:45:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 54D50DAB9E; Wed, 31 Oct 2018 16:45:02 +0100 (CET)
Date:   Wed, 31 Oct 2018 16:45:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     clm@fb.com, jbacik@fb.com, amir73il@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [RFC][PATCH v3 10/10] btrfs: use common file type conversion
Message-ID: <20181031154501.GI9136@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Phillip Potter <phil@philpotter.co.uk>,
        clm@fb.com, jbacik@fb.com, amir73il@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
References: <20181027005331.GA9924@pathfinder>
 <20181027005348.GA9996@pathfinder>
 <20181030190317.GH9136@twin.jikos.cz>
 <20181031092231.GC19486@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031092231.GC19486@pathfinder>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 09:22:31AM +0000, Phillip Potter wrote:
> Thanks for this - are you happy for me to move the compile-time tests as per
> Amir's suggestion?

Yes that's ok.
