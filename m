Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756675AbeFSNNi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 09:13:38 -0400
Date: Tue, 19 Jun 2018 15:10:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Allen Pais <allen.lkml@gmail.com>, linux-btrfs@vger.kernel.org, clm@fb.com,
        jbackik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: stop using get_seconds()
Message-ID: <20180619131041.6v3blgpegciu6fyi@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1528804105-24100-1-git-send-email-allen.lkml@gmail.com>
 <b40f794f-16b6-0369-cb0d-bbb5b12aa46a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b40f794f-16b6-0369-cb0d-bbb5b12aa46a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2018 at 04:07:21PM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.06.2018 14:48, Allen Pais wrote:
> > The get_seconds() function is deprecated as it truncates
> > the timestamp to 32 bits. Change to either ktime_get_seconds()
> > or ktime_get_real_seconds()
> 
> nit: In your patch you are only changing them to get-real-seconds. So
> the "ktime_get_seconds() or" part of the changelog is unnecessary.

Updated, and changed the subject line to "btrfs: replace get_seconds with
new 64bit time API"
