Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59741 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752799AbdC0Nkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:40:36 -0400
Date: Mon, 27 Mar 2017 15:39:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: convert: Make btrfs_reserved_ranges
 const
Message-ID: <20170327133936.GE4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
 <20170316031831.28006-2-quwenruo@cn.fujitsu.com>
 <20170316163325.GL14605@twin.jikos.cz>
 <5c30fbd8-d9e5-b03f-4d0c-6ad7a7dd33cd@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5c30fbd8-d9e5-b03f-4d0c-6ad7a7dd33cd@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 17, 2017 at 08:35:01AM +0800, Qu Wenruo wrote:
> 
> 
> At 03/17/2017 12:33 AM, David Sterba wrote:
> > On Thu, Mar 16, 2017 at 11:18:31AM +0800, Qu Wenruo wrote:
> >> Since btrfs_reserved_ranges array is just used to store btrfs reserved
> >> ranges, no one will nor should modify them at run time, make them static
> >> and const will be better.
> >>
> >> This also eliminates the use of immediate number 3.
> >
> > Adding const is fine, but you shouldn't define the structure inside
> > header, even as static.
> 
> Any reason why we shouldn't define const static array in header?
> 
> Is extra .text segments usage the problem?

No, the problem is definition in a header.
