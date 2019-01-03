Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E86C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B0AA208E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfACOhx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 09:37:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:58088 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbfACOhw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 09:37:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49E03AF69;
        Thu,  3 Jan 2019 14:37:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74372DA781; Thu,  3 Jan 2019 15:37:22 +0100 (CET)
Date:   Thu, 3 Jan 2019 15:37:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v12] btrfs: introduce feature to forget a btrfs
 device
Message-ID: <20190103143722.GG23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546408172-5193-1-git-send-email-anand.jain@oracle.com>
 <1546408172-5193-2-git-send-email-anand.jain@oracle.com>
 <20190102160022.GW23615@twin.jikos.cz>
 <ac8541d7-53e8-74c7-1c45-1cbbf86b8710@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8541d7-53e8-74c7-1c45-1cbbf86b8710@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 03:54:26PM +0800, Anand Jain wrote:
> > I think this should reflect the status of the operation. The ioctl
> > caller has no information about success/error. Eg. an invalid device
> > path passed could return -ENOENT, 0 if it was released and 1 if not.
> > 
> > In case of all devices, it's probably ok to return 0.
> 
> OK. v13 will return error if the given device is not found,
> and I find ENXIO is more suitable (instead of ENOENT).
> If you disagree pls can you make the changes as in [1]
> when integrating. I have tested with both.

ENXIO refers to device nodes, however for paths it should be ok to use
ENOENT, same what would eg. stat return on the given device path.

The ENXIO is used for lseek and is documented as such, I'd rather stick
to semantics of 'file' even though it's a path to a device.
