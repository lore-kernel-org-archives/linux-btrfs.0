Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42357 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751160AbdCNNdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 09:33:21 -0400
Date: Tue, 14 Mar 2017 14:32:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
Message-ID: <20170314133243.GA14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170307151331.GT4662@twin.jikos.cz>
 <e2fe4265-edd0-685e-46b5-b4ae3cf567f9@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e2fe4265-edd0-685e-46b5-b4ae3cf567f9@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 08:28:21AM +0800, Qu Wenruo wrote:
> >> But I must say, that's very frustrating to see bug fixes just get dropped
> >> again and again just due to new cleanups and lack of reviewers.
> >
> > That's life of a kernel developer.
> 
> Right, that's life.
> 
> That's also why I like btrfs-progs a little more.

But you have to deal with the same person there (me), no? :) But yeah,
the userspace programming is considered easier from many aspects.
