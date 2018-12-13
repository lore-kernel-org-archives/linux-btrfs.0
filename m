Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201CAC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB34220811
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 21:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB34220811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbeLMV7u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:59:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:32878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726461AbeLMV7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 16:59:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C318FAEEF;
        Thu, 13 Dec 2018 21:59:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2AEECDA7EE; Thu, 13 Dec 2018 22:59:25 +0100 (CET)
Date:   Thu, 13 Dec 2018 22:59:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andrea Gelmini <andrea.gelmini@gelma.net>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix typos
Message-ID: <20181213215924.GN23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        linux-btrfs@vger.kernel.org
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <20181128155619.GS2842@twin.jikos.cz>
 <20181128161709.GA9917@glet>
 <20181128170247.GW2842@twin.jikos.cz>
 <20181128171237.GB9917@glet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128171237.GB9917@glet>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 06:12:41PM +0100, Andrea Gelmini wrote:
> On Wed, Nov 28, 2018 at 06:02:47PM +0100, David Sterba wrote:
> > You've put your time to find and fix the typos so you deserve the
> > credit. Because you sent them with the signed-off-by line I will use
> 
> Ok, David, thanks a lot.
> So, I'm going to rework the patch with the various suggestion, and
> then re-send it.

I've applied the patch as I need to freeze the development branch for
the upcoming merge window. There were only a few fixups, majority of the
work is from your patch. Thanks.
