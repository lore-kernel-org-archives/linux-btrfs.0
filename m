Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52024 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbaDBOra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 10:47:30 -0400
Date: Wed, 2 Apr 2014 07:47:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <20140402144718.GP22552@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <533C0F7A.7010004@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <533C0F7A.7010004@fb.com>
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 09:24:10AM -0400, Chris Mason wrote:
> On 04/02/2014 04:29 AM, Qu Wenruo wrote:
> >Convert the old btrfs man pages to new asciidoc and split the huge
> >btrfs man page into subcommand man page.
> >
> >The asciidoc style and Makefile things are mostly simplified from git
> >Documentation, which only supports man page output and remove html output,
> >since html output is somewhat overkilled for btrfs.
> 
> Thanks for doing this.  I've never liked roff, but I'll give people
> on the list a chance to complain before taking this one.

1970's called and it wants it troff back :)

More seriously, thanks much for this patch, it makes the source man
pages easier to read and to edit, which is a great thing for keeping them
more up to date.

+10 here.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
