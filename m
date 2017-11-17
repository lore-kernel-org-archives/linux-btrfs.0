Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from internal.daemons-point.com ([83.236.132.110]:46070 "EHLO
        mail.daemons-point.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757164AbdKQQsY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 11:48:24 -0500
Received: from [192.168.0.200] (HSI-KBW-134-3-61-38.hsi14.kabel-badenwuerttemberg.de [134.3.61.38])
        by mail.daemons-point.com (Postfix) with ESMTPSA id 1CFE74863A
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 16:48:12 +0000 (UTC)
From: Uli Heller <uli.heller@daemons-point.com>
Subject: Re: Btrfs progs pre-release 4.14-rc1
To: linux-btrfs@vger.kernel.org
References: <20171114153335.5657-1-dsterba@suse.com>
Message-ID: <66b53cc9-76bc-2864-1b00-cb4a459e0b4e@daemons-point.com>
Date: Fri, 17 Nov 2017 17:48:25 +0100
MIME-Version: 1.0
In-Reply-To: <20171114153335.5657-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to compile these on ubuntu-14.04 running 4.4.0-98-generic
- I had to install libzstd-dev
- I had to disable the zstd tests

Do you think this ends up in a working binary? Or am I doing something 
strange?

Best regards, Uli

-- 
Uli Heller

