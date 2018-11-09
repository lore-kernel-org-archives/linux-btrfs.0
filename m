Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8204C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 12:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E27E20825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 12:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E27E20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbeKIWUb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:20:31 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:43740 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeKIWUb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2018 17:20:31 -0500
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1879284AbeKIMje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 13:39:34 +0100
Date:   Fri, 9 Nov 2018 13:39:34 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, Nick Terrell <terrelln@fb.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Message-ID: <20181109123934.GA10831@router-fw-old.i.net-space.pl>
References: <20181018175541.9532-1-kreijack@libero.it> <20181022110245.GB12705@router-fw-old.i.net-space.pl> <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com> <20181031120623.GA13223@router-fw-old.i.net-space.pl> <71116ba1-997d-44ed-54fa-4b6eff5d8cdd@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71116ba1-997d-44ed-54fa-4b6eff5d8cdd@libero.it>
User-Agent: Mutt/1.3.28i
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

You are welcome!

Daniel
