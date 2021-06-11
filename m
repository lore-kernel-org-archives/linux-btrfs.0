Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B55C48BD1
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jun 2021 16:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA646613D0
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jun 2021 16:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFKQc1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:32:27 -0400
Received: from mail.itouring.de ([85.10.202.141]:49396 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhFKQc1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jun 2021 12:32:27 -0400
Received: from tux.applied-asynchrony.com (p5ddd760d.dip0.t-ipconnect.de [93.221.118.13])
        by mail.itouring.de (Postfix) with ESMTPSA id DB0321259D3;
        Fri, 11 Jun 2021 18:30:27 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 9249FF01606;
        Fri, 11 Jun 2021 18:30:27 +0200 (CEST)
Subject: Re: [PATCH v2] btrfs: sysfs: export dev stats in devinfo directory
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     anand.jain@oracle.com, osandov@osandov.com
References: <20210611133622.12282-1-dsterba@suse.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <d5548a11-3089-c22f-c7d5-39bfbcbe1a06@applied-asynchrony.com>
Date:   Fri, 11 Jun 2021 18:30:27 +0200
MIME-Version: 1.0
In-Reply-To: <20210611133622.12282-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2021-06-11 15:36, David Sterba wrote:
> The device stats can be read by ioctl, wrapped by command 'btrfs device
> stats'. Provide another source where to read the information in
> /sys/fs/btrfs/FSID/devinfo/DEVID/stats . The format is a list of
                                    ^error_stats :)

Otherwise a very welcome improvement, thank you!

cheers
Holger
