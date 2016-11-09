Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbcKIOyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 09:54:35 -0500
Date: Wed, 9 Nov 2016 15:54:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/4] btrfs-progs: utils: Introduce function to escape
 characters
Message-ID: <20161109145429.GZ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
 <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
 <20161107102027.GK12522@twin.jikos.cz>
 <e7291503-310e-3c93-3574-dd1f838d6ad8@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e7291503-310e-3c93-3574-dd1f838d6ad8@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 08:57:52AM +0800, Qu Wenruo wrote:
> And further more.
> 
> The new string escaping is screwing up original output.
> 
> Operation lile mkfile lacks the final '\n'.
> String over the width will lack the ending ' ' to seperate later 
> key=value pairs.

Oh right, that's the shortcut if format is null, this should print the
'\n' as welll, I'll fix it.

> It would be better to output the escaped string into a buffer and still 
> use printf() format to output them out as it used to be.

I want to avoid using the intermediate string buffers unless it's really
necessary.
