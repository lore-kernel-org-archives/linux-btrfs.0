Return-Path: <SRS0=TQMp=4F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE047C34026
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE72820836
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgBQSud (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 13:50:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:37222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgBQSud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Feb 2020 13:50:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 717C4AAFD;
        Mon, 17 Feb 2020 18:50:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 39F1FDA7A0; Mon, 17 Feb 2020 19:50:12 +0100 (CET)
Date:   Mon, 17 Feb 2020 19:50:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/44] docs: filesystems: convert btrfs.txt to ReST
Message-ID: <20200217185011.GI2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
 <1ef76da4ac24a9a6f6187723554733c702ea19ae.1581955849.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef76da4ac24a9a6f6187723554733c702ea19ae.1581955849.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 17, 2020 at 05:11:54PM +0100, Mauro Carvalho Chehab wrote:
> Just trivial changes:
> 
> - Add a SPDX header;
> - Add it to filesystems/index.rst.
> 
> While here, adjust document title, just to make it use the same
> style of the other docs.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Thanks. I can take the patch through btrfs tree, unless Jon wants all
doc patches go through his tree.
