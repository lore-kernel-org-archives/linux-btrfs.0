Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6CBC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4CCA20870
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfDAL6m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:58:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:41748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfDAL6m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 07:58:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22FBFADD9;
        Mon,  1 Apr 2019 11:58:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 493F2DA811; Mon,  1 Apr 2019 13:59:51 +0200 (CEST)
Date:   Mon, 1 Apr 2019 13:59:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     William Muriithi <william@perasotech.com>
Cc:     Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs wiki is down
Message-ID: <20190401115951.GV29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        William Muriithi <william@perasotech.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <BN6PR08MB29486FF5EDEA12AF46E25C7BCE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>
 <20190329164523.GJ27856@carfax.org.uk>
 <BN6PR08MB29489DF5023B1E4E10D36091CE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR08MB29489DF5023B1E4E10D36091CE5A0@BN6PR08MB2948.namprd08.prod.outlook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 05:21:09PM +0000, William Muriithi wrote:
> Hi Hugo
> 
> >>
> >> Not sure I should be raising this here, but I can't find another reliable email.  I suspect someone here would be able to reach out to those responsible for the wiki.
> >>
> >> https://btrfs.wiki.kernel.org/index.php/Status
> >
> >   It's working for me. Maybe it was a transient while someone was
> >fiddling with it, that's already been fixed?
> 
> Hmm, it is indeed up.  I had saved the link on a file and just realized it had some hidden text.  This is what I actually used initially.
> 
> https://btrfs.wiki.kernel.org/index.php/Status%E2%80%8B
> 
> I think it should fail with a 404 error instead of the current mysql connection issue error.

I'll forward it to k.org admins, thanks.
