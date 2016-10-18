Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41481 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755021AbcJRMHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 08:07:51 -0400
Date: Tue, 18 Oct 2016 14:07:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam
 and dump send stream
Message-ID: <20161018120749.GO11398@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz>
 <20160908095613.GL16983@twin.jikos.cz>
 <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 03:32:53PM +0800, Qu Wenruo wrote:
> Hi David,
> 
> Any updates?
> 
> If you're busy on these fix, I could fix these problem and send a new 
> version.

I was about to add the series to merge but the output format needs work.
At minimum, something that's parseable, so some commonly used format
(yaml or json). The current way is ok for quick overview, but I'd really
like to see more options of the output. The malloc/free problems are
minor.
