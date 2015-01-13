Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbbAMSSI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 13:18:08 -0500
Date: Tue, 13 Jan 2015 19:18:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] Btrfs: fix unused members in struct btrfs_root
Message-ID: <20150113181805.GK3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421078887-29970-1-git-send-email-anand.jain@oracle.com>
 <CAL3q7H6zoiMmBPyoCSGvhcMZ65wR2_7gENgku=YkQV4XyXC_uA@mail.gmail.com>
 <54B3FA3F.6070907@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54B3FA3F.6070907@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 12:45:51AM +0800, Anand Jain wrote:
> 
> Thanks Filipe for pointing out.
> my hands moved too fast, 2 concurrent calls case didn't pop in mind.
> sorry my mistake.  I see other two members (root_kobj and 
> kobj_unregister) are still not used.

Yes, they seem to be a leftover from the first iteration of sysfs code.
