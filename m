Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC72C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79B32086A
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E79B32086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbeKNAaF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 19:30:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:44206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727166AbeKNAaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 19:30:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F070FB168;
        Tue, 13 Nov 2018 14:31:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 02AA5DAD3E; Tue, 13 Nov 2018 15:31:22 +0100 (CET)
Date:   Tue, 13 Nov 2018 15:31:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
Message-ID: <20181113143121.GZ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108131750.27833-1-fdmanana@kernel.org>
 <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 08, 2018 at 02:48:29PM +0000, Filipe Manana wrote:
> On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wrote:
> >
> > On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> > >
> > >
> > >
> > > On 2018/11/8 下午9:17, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > When creating a block group we don't need to set the log for full commit
> > > > if the new block group is not used for data. Logged items can only point
> > > > to logical addresses of data block groups (through file extent items) so
> > > > there is no need to for the next fsync to fallback to a transaction commit
> > > > if the new block group is for metadata.
> > >
> > > Is it possible for the log tree blocks to be allocated in that new block
> > > group?
> >
> > Yes.
> 
> Now I realize what might be your concern, and this would cause trouble.

Is this patch ok for for-next or does it need more work? Thanks.
