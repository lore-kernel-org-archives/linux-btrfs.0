Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A90CC4360F
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 05:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA49C222DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 05:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfBPFkB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 00:40:01 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50544 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbfBPFkB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 00:40:01 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 16 Feb 2019 16:09:58 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gushh-0000EJ-D0; Sat, 16 Feb 2019 16:39:57 +1100
Date:   Sat, 16 Feb 2019 16:39:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-btrfs@vger.kernel.org, hare@suse.de
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190216053957.GU20493@dastard>
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190216053133.GT20493@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
> On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> > (This is a joint proposal with Hannes Reinecke)
> > 
> > Servers with NV-DIMM are slowly emerging in data centers but one key feature
> > for reliability of these systems hasn't been addressed up to now, data
> > redundancy.
> > 
> > While it would be best to solve this issue in the memory controller of the CPU
> > itself, I don't see this coming in the next few years. This puts us as the OS
> > in the burden to create the redundant copies of data for the users.
> > 
> > If we leave of the DAX support Linux' software RAID implementations (MD,
> > device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> > are incompatible with DAX.
> > 
> > In this session Hannes and I would like to discuss eventual ways how we as an
> > operating system can mitigate these issues for our users.
> 
> We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> allow per-device dax status checking for filesystems"). That is,
> we can have DAX on the XFS RT device indepently of the data device.
> 
> That is, you set up pmem in three segments - two small identical
> segments start get mirrored with RAID1 as the data device, and
> the remainder as a block device that is dax capable set up as the
> XFS realtime device. Set the RTINHERIT bit on the root directory at
> mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> capable realtime device, and all the metadata goes to the software
> raided pmem block devices that aren't DAX capable.
> 
> Problem already solved, yes?

Sorry, this was meant to be a reply to Dan's email commenting about
some people needing mirrored metadata, not the parent that was
talking about whole device RAID...

i.e. mirrored metadata w/ FS-DAX for data should already be a solved
problem...

Cheers,

Dave.
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Dave Chinner
david@fromorbit.com
