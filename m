Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:60884 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751192AbdITQxT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 12:53:19 -0400
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
To: nborisov <nborisov@suse.de>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
 <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
 <a7334014-9f8e-55e0-83d1-0c14ce1522f6@gmx.com>
 <8df27746-487b-c5f2-59a0-8eb24b95571a@gmx.com>
 <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
 <25600b6b3bd712edb60962357c42d163@suse.de>
 <c0be1b97-43d1-1ebb-f745-b7308e6a9eba@gmx.com>
 <2e940d95b1e00ebb2a873b89760ec236@suse.de>
From: Rich Rauenzahn <rich@shroop.net>
Message-ID: <34aba268-300b-3cfc-8854-3f0661832af7@shroop.net>
Date: Wed, 20 Sep 2017 09:53:13 -0700
MIME-Version: 1.0
In-Reply-To: <2e940d95b1e00ebb2a873b89760ec236@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For the warning -- is there anyway to add in the filesystem/disk causing 
the issue?  I didn't see any identifier in the message that told me 
which it was.
