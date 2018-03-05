Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbeCEP23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 10:28:29 -0500
Date: Mon, 5 Mar 2018 07:28:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs space used issue
Message-ID: <20180305152827.GA27477@infradead.org>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
 <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
 <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
 <CAFmraXhRtUh-HPV4vpeE3-0B=vCeK40b2HfsOk_boSFu+EjQhg@mail.gmail.com>
 <pan$bee0f$57d3b021$cd11cf8a$d3c1d93d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$bee0f$57d3b021$cd11cf8a$d3c1d93d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 03, 2018 at 06:59:26AM +0000, Duncan wrote:
> Indeed.  Preallocation with COW doesn't make the sense it does on an 
> overwrite-in-place filesystem.

It makes a whole lot of sense, it just is a little harder to implement.

There is no reason not to preallocate specific space, or if you aren't
forced to be fully log structured by the medium, specific blocks to
COW into.  It just isn't quite as trivial as for a rewrite in place
file system to implement.
