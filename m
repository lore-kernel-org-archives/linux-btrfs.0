Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41705 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeCVNly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:41:54 -0400
Date: Thu, 22 Mar 2018 14:39:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Use macro to replace
 immediate number for readable flags string buffer length
Message-ID: <20180322133927.GZ6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180322073711.5943-1-wqu@suse.com>
 <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
 <7076d888-34ee-d9d9-8187-8d024b5a1465@gmx.com>
 <3792de77-6b0d-dd8c-7cca-05391a1c0169@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <3792de77-6b0d-dd8c-7cca-05391a1c0169@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2018 at 10:40:22AM +0200, Nikolay Borisov wrote:
> On 22.03.2018 10:32, Qu Wenruo wrote:
> > On 2018年03月22日 16:20, Nikolay Borisov wrote:
> >> On 22.03.2018 09:37, Qu Wenruo wrote:
> >>> In print-tree, we have a lot of parsers to convert numeric flags to
> >>> human readable string.
> >>>
> >>> For the buffer size we're using immediate numbers for all their callers.
> >>> Change this to macro so it will be much easier for us to expand the
> >>> buffer size.
> >>>
> >>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>
> >> The changes look good per se, however I'd like to have all such macros
> >> grouped at the beginning of the file - in their own section so to speak.
> >>
> > 
> > That's also what I considered.
> > However this makes stack consumption larger for some callers who don't
> > really need that much buffer size.
> 
> I just meant to have the multiple defines you've introduced grouped at
> the beginning of the file. Not having one define for everyone. This is
> done purely for aesthetics purposes, though I'm not too hung up on that
> so if you decide to ignore it, it's fine.

No, that's actually what I prefer, the first part of header or source is
for defintions. Unless it's really local to the function or single use.
