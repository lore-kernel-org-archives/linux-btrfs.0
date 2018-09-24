Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbeIXOJ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 10:09:27 -0400
Subject: Re: python-btrfs v10 preview... detailed usage reporting and a
 tutorial
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f50f64a5-eec5-da34-d07b-0a76d108f044@suse.com>
Date: Mon, 24 Sep 2018 11:08:31 +0300
MIME-Version: 1.0
In-Reply-To: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.09.2018 00:54, Hans van Kranenburg wrote:
<snip>

.
> 
> The bugs are all related to repeated kernel code all over the place
> containing a lot of if statements dealing with different kind of
> allocation profiles and their exceptions. What I ended up doing is
> making a few helper functions instead, see the commit "Add volumes.py,
> handling device / chunk logic". It would probably be nice to do the same
> in the kernel code, which would also solve the mentioned bugs and
> prevent new similar ones from happening.

Would you care to report each bug separately so they can be triaged and
fixed?

> 
> Have fun,
> 
