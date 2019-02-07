Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28688C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 15:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0219D20863
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 15:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfBGPlX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:41:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:54578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfBGPlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 10:41:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46268AFCC;
        Thu,  7 Feb 2019 15:41:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52761DA83D; Thu,  7 Feb 2019 16:40:45 +0100 (CET)
Date:   Thu, 7 Feb 2019 16:40:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     dennis@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: change set_level() to bound the level passed
 in
Message-ID: <20190207154045.GI2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        dennis@kernel.org, linux-btrfs@vger.kernel.org
References: <20190207103647.GA15902@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207103647.GA15902@kadam>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 07, 2019 at 01:36:47PM +0300, Dan Carpenter wrote:
> Hello Dennis Zhou,
> 
> The patch a67dc67a2cb8: "btrfs: change set_level() to bound the level
> passed in" from Jan 28, 2019, leads to the following static checker
> warning:
> 
> 	fs/btrfs/compression.c:1576 btrfs_compress_str2level()
> 	error: uninitialized symbol 'level'.
> 
> fs/btrfs/compression.c
>     1566 unsigned int btrfs_compress_str2level(unsigned int type, const char *str)
>     1567 {
>     1568 	unsigned int level;
>     1569 	int ret;
>     1570 
>     1571 	if (!type)
>     1572 		return 0;
>     1573 
>     1574 	if (str[0] == ':') {
>     1575 		ret = kstrtouint(str + 1, 10, &level);
> --> 1576 		if (ret)
>     1577 			level = 0;
> 
> I feel like if the user gives bad input then we should just return an
> error code instead of picking a level.

We've debated a bit and a warning with fallback to default is the
preferred option.
> 
>     1578 	}
> 
> level is not initialized if the first character is not ':'.

Right that's a bug, can be fixed by initializing level to 0, the
set_level() implementations will fall back to default then.

Thanks for the report.

> 
>     1579 
>     1580 	level = btrfs_compress_op[type]->set_level(level);
>     1581 
>     1582 	return level;
>     1583 }
