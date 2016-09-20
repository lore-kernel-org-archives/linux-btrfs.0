Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:43380
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755286AbcITQHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 12:07:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 20 Sep 2016 10:06:32 -0600
From: lakshmipathi.g@giis.co.in
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH]btrfs-progs: Add fast,slow symlinks and fifo types to
 convert test
In-Reply-To: <89977db3-aae4-01d1-62a2-34011e0227f8@cn.fujitsu.com>
References: <20160915093407.GA17835@fedori>
 <89977db3-aae4-01d1-62a2-34011e0227f8@cn.fujitsu.com>
Message-ID: <b2023d1951468ffa209c2daa85282be2@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-19 18:21, Qu Wenruo wrote:
> Just curious, did the new fifo/slow_symlink exposed any convert bug?
> 
> Thanks,
> Qu
Unfortunately no. I was hoping something will fail, but sadly 
convert-tests.sh passed!
