Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48792C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2212920842
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfB0Rm0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:42:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:42122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727400AbfB0RmZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 12:42:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1AA2AE08;
        Wed, 27 Feb 2019 17:42:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0FE0DA83C; Wed, 27 Feb 2019 18:43:45 +0100 (CET)
Date:   Wed, 27 Feb 2019 18:43:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.20.2
Message-ID: <20190227174345.GA31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20190225180438.4249-1-dsterba@suse.com>
 <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03a1aba5-3a19-25fe-de3a-d99ad32d2edd@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 26, 2019 at 01:06:48PM +0800, Anand Jain wrote:
> 
> 
>   https://patchwork.kernel.org/patch/10732689/
> 
> Would like to bring to your notice. Above patch is not yet integrated 
> for a long time. Any comments?

I'm too busy with kernel patches to don't at progs very often. For
unknown reasons the quality of incoming patches has dropped so I have to
spend way more time testing and making sure that what gets merged does
not regress.

I see the pings and tag all progs patches but otherwise need to find a
calm week so I can switch to the other codebase.
