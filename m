Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbaDCUdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Apr 2014 16:33:51 -0400
Date: Thu, 3 Apr 2014 13:33:47 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140403203347.GD24290@lenny.home.zabbo.net>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
 <533C0F7A.7010004@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <533C0F7A.7010004@fb.com>
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

Moving to asciidoc is definitely the right thing to do.  Dave's also
been moving the xfs docs in this direction.

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-documentation.git;a=summary

- z
