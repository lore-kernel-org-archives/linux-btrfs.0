Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44709 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753682AbdJSRJ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 13:09:27 -0400
Date: Thu, 19 Oct 2017 19:07:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: increase output size for LOGICAL_INO_V2 ioctl
Message-ID: <20171019170740.GO3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
 <20170922175847.6071-4-ce3g8jdj@umail.furryterror.org>
 <c2778a9a-3d94-7888-657c-317c5bbf1ed7@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c2778a9a-3d94-7888-657c-317c5bbf1ed7@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Sep 23, 2017 at 11:06:42PM +0200, Hans van Kranenburg wrote:
> Reviewed-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Tested-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

the patches look good to me and the usecase and testing coverage seem
sufficient to take the patches to 4.15, though we're close to the
informal merging deadline.
