Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:47009 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbeIDQKp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 12:10:45 -0400
Message-ID: <6814364da02fd7e71e31c25d7928b2dfab7b133a.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Su Yue <Damenly_Su@gmx.com>
Date: Tue, 04 Sep 2018 13:45:56 +0200
In-Reply-To: <c048dacc-7164-6739-252c-c46448a5fed2@gmx.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <c048dacc-7164-6739-252c-c46448a5fed2@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2018-09-04 at 17:14 +0800, Qu Wenruo wrote:
> However the backtrace can't tell which process caused such fsync
> call.
> (Maybe LVM user space code?)

Well it was just literally before btrfs-check exited... so I blindly
guesses... but arguably it could be just some coincidence.

LVM tools are installed, but since I no longer use and PVs/LVs/etc. ...
I'd doubt they'd do anything here.


Cheers,
Chris.
