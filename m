Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39791 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753320AbdCPQeL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 12:34:11 -0400
Date: Thu, 16 Mar 2017 17:33:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: convert: Make btrfs_reserved_ranges
 const
Message-ID: <20170316163325.GL14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
 <20170316031831.28006-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316031831.28006-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 11:18:31AM +0800, Qu Wenruo wrote:
> Since btrfs_reserved_ranges array is just used to store btrfs reserved
> ranges, no one will nor should modify them at run time, make them static
> and const will be better.
> 
> This also eliminates the use of immediate number 3.

Adding const is fine, but you shouldn't define the structure inside
header, even as static. The number 3 needs to stay so we can use
ARRAY_SIZE.
