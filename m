Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F56C10F00
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0033C217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfBSD7P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 22:59:15 -0500
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:2718 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfBSD7O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 22:59:14 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl2.internode.on.net with ESMTP; 19 Feb 2019 14:29:10 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gvwYo-0004O1-5U; Tue, 19 Feb 2019 14:59:10 +1100
Date:   Tue, 19 Feb 2019 14:59:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jane Chu <jane.chu@oracle.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>, linux-nvdimm@lists.01.org,
        linux-block@vger.kernel.org, hare@suse.de,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190219035910.GA15503@dastard>
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard>
 <20190216053957.GU20493@dastard>
 <d7037b76-8bbe-412d-387a-4e27db26b005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7037b76-8bbe-412d-387a-4e27db26b005@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 06:15:34PM -0800, Jane Chu wrote:
> On 2/15/2019 9:39 PM, Dave Chinner wrote:
> 
> >On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
> >>On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> >>>(This is a joint proposal with Hannes Reinecke)
> >>>
> >>>Servers with NV-DIMM are slowly emerging in data centers but one key feature
> >>>for reliability of these systems hasn't been addressed up to now, data
> >>>redundancy.
> >>>
> >>>While it would be best to solve this issue in the memory controller of the CPU
> >>>itself, I don't see this coming in the next few years. This puts us as the OS
> >>>in the burden to create the redundant copies of data for the users.
> >>>
> >>>If we leave of the DAX support Linux' software RAID implementations (MD,
> >>>device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> >>>are incompatible with DAX.
> >>>
> >>>In this session Hannes and I would like to discuss eventual ways how we as an
> >>>operating system can mitigate these issues for our users.
> >>We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> >>allow per-device dax status checking for filesystems"). That is,
> >>we can have DAX on the XFS RT device indepently of the data device.
> >>
> >>That is, you set up pmem in three segments - two small identical
> >>segments start get mirrored with RAID1 as the data device, and
> >>the remainder as a block device that is dax capable set up as the
> >>XFS realtime device. Set the RTINHERIT bit on the root directory at
> >>mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> >>capable realtime device, and all the metadata goes to the software
> >>raided pmem block devices that aren't DAX capable.
> >>
> >>Problem already solved, yes?
> >Sorry, this was meant to be a reply to Dan's email commenting about
> >some people needing mirrored metadata, not the parent that was
> >talking about whole device RAID...
> >
> >i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> >problem...
> 
> What about DAX Ext4 filesystem? What could be done for the EXT4
> filesystem metadata?

AFAIK, this can't be supported with ext4 right now. You'll have to
either use hardware DIMM mirroring or wait to see if full device
mirroring can be done in software and still preserve DAX (which is
what the original proposal is about).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
