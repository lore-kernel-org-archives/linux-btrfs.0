Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750829AbdF1IuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 04:50:20 -0400
Subject: Re: [QUESTION] xfstest generic/015 run failed
To: Dai Xiang <xiangx.dai@intel.com>, linux-btrfs@vger.kernel.org
References: <20170628055914.GA11753@localhost>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0bd92f3d-6c63-6984-6ff0-6ae5dd87a2fe@suse.com>
Date: Wed, 28 Jun 2017 11:50:17 +0300
MIME-Version: 1.0
In-Reply-To: <20170628055914.GA11753@localhost>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.06.2017 08:59, Dai Xiang wrote:
> Hi! I test on my host and find below issue, i want to know how can fix it?
> 
> root@ubuntu ~/xfstests# ./check generic/015
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 ubuntu 4.12.0-rc6

I don't observe this failure on rc6/rc7
