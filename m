Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3JXOvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:51:03 -0400
Date: Thu, 24 Oct 2013 16:51:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
Message-ID: <20131024145100.GC28149@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
 <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
 <20131022143303.GU1032@twin.jikos.cz>
 <52672F90.8060804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52672F90.8060804@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 10:08:16AM +0800, Anand Jain wrote:
> On 10/22/13 10:33 PM, David Sterba wrote:
> >On Tue, Oct 22, 2013 at 01:53:22PM +0800, Anand Jain wrote:
> >>@@ -386,7 +395,7 @@ static int btrfs_scan_kernel(void *search)
> >>  static const char * const cmd_show_usage[] = {
> >>-	"btrfs filesystem show [options] [<path>|<uuid>]",
> >>+	"btrfs filesystem show [options|<path>|<uuid>]",
> >
> >Options should stay separate from the path/uuid, you're extending the
> >syntax to accept a device:
> >
> >	"btrfs filesystem show [options] [<path>|<uuid>|<device>]",
> >
> >I'm fixing it locally, let me know if this doesn't match what you've
> >intended.
> 
>  I am confused, on how the options should be represented,
>  but the internal design is as below.

Hm right, it is a bit confusing, I think because of the syntax that
allows either options or the path/uuid/device specifier, not both, which
is not so common.

I still prefer to keep them separate, because it's something that can be
clarified in the help text or documentation.

Besides, that we may want to add more options that affect
path/uuid/device output, the argument description looks consistent with
other commands and if some combination is not allowed, then an error
message will say why. I really don't expect an average user to think too
hard about it.

david
