Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41185 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754737AbcJNRNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 13:13:42 -0400
Date: Fri, 14 Oct 2016 18:54:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Abhay Sachan <lkp.abhay@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs build fails for 4.8
Message-ID: <20161014165429.GC11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 07:28:20PM +0530, Abhay Sachan wrote:
> Hi,
> I tried building latest btrfs progs on CentOS 6, "./configure" failed
> with the error:
> 
> checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
> configure: error: no definition of FIEMAP_EXTENT_SHARED found
> 
> Any ideas what am I lacking in the system?

Can you please test the build from current devel branch? [1] Configure
will just print a warning if the flag is not defined, 'btrfs fi du' will
print another warning if it's running on kernel < 2.6.33 .

[1] git://github.com/kdave/btrfs-progs (branch devel)
