Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751974AbdF2Oj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 10:39:26 -0400
Date: Thu, 29 Jun 2017 16:38:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Dai Xiang <xiangx.dai@intel.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [QUESTION] xfstest generic/015 run failed
Message-ID: <20170629143815.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628055914.GA11753@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170628055914.GA11753@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 01:59:14PM +0800, Dai Xiang wrote:
> Hi! I test on my host and find below issue, i want to know how can fix it?

The test purpose would need to be better defined, the file header says
"check out-of-space behaviour". Not really helpful.  The test script
creates a 50MB filesystem, fills it, removes the file and compares what
'df' reports. The test result can change depending eg. on the mkfs
options, if compression is enabled. So if the test fails, it does not
tell us much. I would not worry about it.
