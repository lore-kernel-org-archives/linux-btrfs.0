Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:53714 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbeC1X7L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 19:59:11 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 49F2AAC01E6
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 08:59:03 +0900 (JST)
Subject: Re: error report: misc-test 006 sometimes fails in current devel
 branch
To: linux-btrfs <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>
References: <cfacefc4-3bd0-8e27-3c51-d681502da6ae@jp.fujitsu.com>
 <20180328145000.GK30422@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <556cc71d-363a-e16b-04cc-37e574f442c7@jp.fujitsu.com>
Date: Thu, 29 Mar 2018 08:58:56 +0900
MIME-Version: 1.0
In-Reply-To: <20180328145000.GK30422@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/28 23:50, David Sterba wrote:
> On Wed, Mar 28, 2018 at 10:55:56AM +0900, Misono Tomohiro wrote:
>> current devel branch of btrfs-progs (github) occasionally fails at misc-test 006:
>> (kernel is 4.16.0-rc7)
> 
> Can you please also open an issue on github, with the details attached? Thanks.

Yes, I opened the issue: https://github.com/kdave/btrfs-progs/issues/118

