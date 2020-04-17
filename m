Return-Path: <SRS0=V6R8=6B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6539FC2BA2B
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 00:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20A35221EB
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 00:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgDQALL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 20:11:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgDQALK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Apr 2020 20:11:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 40F5DABD2;
        Fri, 17 Apr 2020 00:11:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 56F5BDA727; Fri, 17 Apr 2020 02:10:29 +0200 (CEST)
Date:   Fri, 17 Apr 2020 02:10:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     Oliver <oliver111333777@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: cancel resize
Message-ID: <20200417001029.GN5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Oliver <oliver111333777@gmail.com>, linux-btrfs@vger.kernel.org
References: <1c779cba-5d1c-0bca-38bf-af5cd572a9d0@gmail.com>
 <20200412024954.GQ13306@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412024954.GQ13306@hungrycats.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 11, 2020 at 10:49:54PM -0400, Zygo Blaxell wrote:
> On Sun, Apr 12, 2020 at 01:52:01AM +0200, Oliver wrote:
> > Hello,
> > 
> > I've made a stupid mistake. I wanted to reduce a disk with 1990m, but
> > instead resized it to 1990m.
> > 
> > btrfs fi resize 2:1990m /btrfs
> > 
> > It will take forever and might fail in the end, as I might not have enough
> > space avaiable.
> > 
> > How do I cancel this operation ? I can see cancel operations for other
> > commands, but not this one.
> 
> Currently, the only ways to stop a device shrink or remove are to run
> out of space or reboot.
> 
> Patches welcome!

This will need either a new ioctl or a bit dirty extension to the
current one, as the resize request is a string so 'cancel' will stop
current resize in case it's running.
