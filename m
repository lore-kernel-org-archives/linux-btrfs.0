Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:33970 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeIERDw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 13:03:52 -0400
Message-ID: <37c6a0bd07091b71ead2650bc8e82a02dfffd5b3.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Su Yue <Damenly_Su@gmx.com>
Date: Wed, 05 Sep 2018 14:33:44 +0200
In-Reply-To: <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2018-09-05 at 15:04 +0800, Su Yue wrote:
> Agreed with Qu, btrfs-check shall not try to do any write.

Well.. it could have been just some coincidence :-)


> I found the errors should blame to something about inode_extref check
> in lowmem mode.

So you mean errors in btrfs-check... and it was a false positive?


> I have writeen three patches to detect and report errors about
> inode_extref. For your convenience, it's based on v4.17:
> https://github.com/Damenly/btrfs-progs/tree/ext_ref_v4.17

I hope I can test them soon.... could take a bit longer as I'm about to
head off into vacation.


Cheers,
Chris.
