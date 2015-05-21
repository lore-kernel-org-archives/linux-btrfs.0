Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbbEUPOe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 11:14:34 -0400
Date: Thu, 21 May 2015 17:14:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/27 V5] provide framework so that sysfs attributs from
 the fs_devices can be added
Message-ID: <20150521151432.GU23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
 <55239094.2010109@oracle.com>
 <20150520164039.GK23255@twin.jikos.cz>
 <555DF054.4080707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <555DF054.4080707@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 10:48:52PM +0800, Anand Jain wrote:
> 
>   some confusion, sorry about that. will get seed-fsid under seeding dir.

Great, thanks.

>   (However seeding name was already used by an (upcoming) attribute
>   (fs_devices->seeding), but now I am thinking seeding as a kobject dir
>   is better, so will rename the attribute to something else.. like
>   seeding_flag).

If 'seeding' is already reserved, then 'seed' for the directory would be
fine.
