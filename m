Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932849AbdHVOcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:32:55 -0400
Date: Tue, 22 Aug 2017 16:31:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Use named constants for common sizes
Message-ID: <20170822143130.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1501143420-28062-1-git-send-email-nborisov@suse.com>
 <1501143420-28062-2-git-send-email-nborisov@suse.com>
 <pan$9b8a8$c35443cf$d85bd4b7$f5299060@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$9b8a8$c35443cf$d85bd4b7$f5299060@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 09:02:12PM +0000, Duncan wrote:
> Nikolay Borisov posted on Thu, 27 Jul 2017 11:17:00 +0300 as excerpted:
> 
> > diff --git a/convert/main.c b/convert/main.c
> > index c56382e915fd..49ab829b5641 100644
> > --- a/convert/main.c
> > +++ b/convert/main.c
> 
> > @@ -1586,7 +1586,7 @@ next:
> >   * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
> >   * |   0~1M    |  | Fs   |   | SB2 + 64K | | Fs   | | SB3 + 64K |
> >   *
> > - * On the other hande, the converted fs image in btrfs is a completely 
> > + * On the other hande, the converted fs image in btrfs is a completely
> >   * valid old fs.
> >   *
> >   * |<-----------------Converted fs image in btrfs-------------------->|
> 
> If you're going to kill the line-terminating space, you might as well
> do the spell-correct in the same line:
> 
> s/hande/hand/

Fixed.
