Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08124C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 18:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B060620664
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 18:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B060620664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbeKAD6G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 23:58:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:48556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730097AbeKAD6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 23:58:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 728F3B166;
        Wed, 31 Oct 2018 18:58:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 79BADDAB9E; Wed, 31 Oct 2018 19:58:35 +0100 (CET)
Date:   Wed, 31 Oct 2018 19:58:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, Nick Terrell <terrelln@fb.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Message-ID: <20181031185835.GK9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, kreijack@inwind.it,
        Daniel Kiper <dkiper@net-space.pl>, Nick Terrell <terrelln@fb.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181018175541.9532-1-kreijack@libero.it>
 <20181022110245.GB12705@router-fw-old.i.net-space.pl>
 <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com>
 <20181031120623.GA13223@router-fw-old.i.net-space.pl>
 <71116ba1-997d-44ed-54fa-4b6eff5d8cdd@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71116ba1-997d-44ed-54fa-4b6eff5d8cdd@libero.it>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 07:48:08PM +0100, Goffredo Baroncelli wrote:
> On 31/10/2018 13.06, Daniel Kiper wrote:
> [...]
> > 
> > v11 pushed.
> > 
> > Goffredo, thank you for doing the work.
> 
> Great ! Many thanks for your support !!

Thank you very much for the work! I've updated wiki with the good news.
