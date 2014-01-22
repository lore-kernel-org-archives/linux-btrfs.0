Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaAVMMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:12:21 -0500
Date: Wed, 22 Jan 2014 13:12:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140122121220.GF6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <lbid3r$1ui$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <lbid3r$1ui$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 19, 2014 at 09:44:39PM -0800, Roger Binns wrote:
> If you are more interested in the theoretical side then looking into
> compression would be interesting.  ie how close to the theoretical best
> compression are we.  Various filesystems like btrfs and NTFS make all
> sorts of compromises in algorithm choices but also especially in the size
> of blocks they compress.  How much better could be done?

I have done some work here, so far it's stalled due to more important
work.

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Compression_enhancements

Do you have other suggestions beyond what's proposed there?
