Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5D8C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 22:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0776D2084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 22:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfDBWNt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 18:13:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:53458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfDBWNt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 18:13:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D25B7AC94;
        Tue,  2 Apr 2019 22:13:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E51A3DA824; Wed,  3 Apr 2019 00:14:57 +0200 (CEST)
Date:   Wed, 3 Apr 2019 00:14:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4 RESEND] btrfs: fix vanished compression property
 after failed set
Message-ID: <20190402221457.GJ29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-4-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402100742.8355-4-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 06:07:40PM +0800, Anand Jain wrote:
> The compression property resets to NULL, instead of the old value if we
> fail to set the new compression parameter.
> 
> btrfs prop get /btrfs compression
>   compression=lzo
> btrfs prop set /btrfs compression zli
>   ERROR: failed to set compression for /btrfs: Invalid argument
> btrfs prop get /btrfs compression
> 
> This is because the compression property ->validate() is successful for
> 'zli' as the strncmp() used the len passed from the userland.
> 
> Fix it by using the expected string length in strncmp().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
