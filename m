Return-Path: <SRS0=4n2k=37=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31319C35242
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 19:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F2AC20848
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 19:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgBKTjf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 14:39:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:38056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbgBKTjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Feb 2020 14:39:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 464F9ACD7;
        Tue, 11 Feb 2020 19:39:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82A40DA703; Tue, 11 Feb 2020 20:39:19 +0100 (CET)
Date:   Tue, 11 Feb 2020 20:39:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <mpdesouza@suse.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org,
        hch@infradead.org, josef@toxicpanda.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCHv3] btrfs: Introduce new BTRFS_IOC_SNAP_DESTROY_V2 ioctl
Message-ID: <20200211193918.GI2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <mpdesouza@suse.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org,
        hch@infradead.org, josef@toxicpanda.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        clang-built-linux@googlegroups.com
References: <20200207130546.6771-1-marcos.souza.org@gmail.com>
 <20200210234158.GA37636@ubuntu-x2-xlarge-x86>
 <45c807f4298b22eaa1a89741bee67721fa0b0f80.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c807f4298b22eaa1a89741bee67721fa0b0f80.camel@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 11, 2020 at 03:57:21PM -0300, Marcos Paulo de Souza wrote:
> > We received a build report from the 0day bot when building with clang
> > that appears legitimate if I am reading everything correctly.
> > 
> > ../fs/btrfs/ioctl.c:2867:4: warning: array index 4087 is past the end
> > of the array (which contains 4040 elements) [-Warray-bounds]
> >                         vol_args2->name[BTRFS_PATH_NAME_MAX] = '\0';
> >                         ^               ~~~~~~~~~~~~~~~~~~~
> > ../include/uapi/linux/btrfs.h:125:3: note: array 'name' declared here
> >                 char name[BTRFS_SUBVOL_NAME_MAX + 1];
> >                 ^
> > 1 warning generated.
> 
> Sure, I will send a new patch to address this warning after this one
> gets merged, since this problem existed before this change. Thanks for
> the report!

Actually the warning is correct because you used a different macro:
BTRFS_PATH_NAME_MAX (4087) instead of BTRFS_SUBVOL_NAME_MAX (4039).
