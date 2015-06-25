Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbbFYPKb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 11:10:31 -0400
Date: Thu, 25 Jun 2015 17:10:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs stable updates for 4.0
Message-ID: <20150625151029.GI726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1434037853.git.dsterba@suse.cz>
 <20150619203131.GC22717@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150619203131.GC22717@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 01:31:31PM -0700, Greg KH wrote:
> > 	5cc2b17e80cf5770f2e585c2d90fd8af1b901258 # 3.14+
> 
> Does not build on 3.14+, sorry.  Please provide a backported version if
> you want to see it there.

I'm sorry about the hassle with applying to older version. My main
goal is to provide a set of patches for the latest stable series, and
they get reviewed and tested properly. I try to look whether the patches
are relvant for older versions but this takes extra time. I don't have
particular interest in these so it's only best effort, but so far it
hasn't met the 'best' premise. I'll try better next time.
