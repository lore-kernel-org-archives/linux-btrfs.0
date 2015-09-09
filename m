Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbbIIN1H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 09:27:07 -0400
Date: Wed, 9 Sep 2015 15:26:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Vytautas D <vytdau@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, clm@fb.com
Subject: Re: Btrfs progs release 4.1
Message-ID: <20150909132621.GI8891@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150622150023.GX6761@twin.jikos.cz>
 <55EF8CBD.3020105@cn.fujitsu.com>
 <55EFA661.2050102@cn.fujitsu.com>
 <CAO5K3Oemuice_3RMxsdQVOxWv+izVAFNN0p_shcbD=ONdrWGOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO5K3Oemuice_3RMxsdQVOxWv+izVAFNN0p_shcbD=ONdrWGOg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 11:35:50AM +0100, Vytautas D wrote:
> sorry for side question - but does this mean that btrfs-convert issues
> others were having on kernel 4.0+ on this mailing list is now
> addressed ?

Per Qu's analysis yes, the broken versions are 3.19.1-4.0.1.
