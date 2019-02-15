Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A4DC10F02
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 09:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 215BF21B1A
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 09:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405381AbfBOJ5O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:57:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:36444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733056AbfBOJ5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 04:57:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7936CAF76;
        Fri, 15 Feb 2019 09:57:12 +0000 (UTC)
Date:   Fri, 15 Feb 2019 10:57:12 +0100
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-btrfs@vger.kernel.org,
        hare@suse.de
Subject: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190215095710.GA12279@linux-x5ow.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

(This is a joint proposal with Hannes Reinecke)

Servers with NV-DIMM are slowly emerging in data centers but one key feature
for reliability of these systems hasn't been addressed up to now, data
redundancy.

While it would be best to solve this issue in the memory controller of the CPU
itself, I don't see this coming in the next few years. This puts us as the OS
in the burden to create the redundant copies of data for the users.

If we leave of the DAX support Linux' software RAID implementations (MD,
device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
are incompatible with DAX.

In this session Hannes and I would like to discuss eventual ways how we as an
operating system can mitigate these issues for our users.

Byte,
	Johannes

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
