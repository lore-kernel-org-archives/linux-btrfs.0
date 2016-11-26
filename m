Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40320 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbcKZK10 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 05:27:26 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cAaCR-0005Aa-1x
        for linux-btrfs@vger.kernel.org; Sat, 26 Nov 2016 11:27:15 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: mount option nodatacow for VMs on SSD?
Date: Sat, 26 Nov 2016 11:27:10 +0100
Message-ID: <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 25 Nov 2016 09:28:40 +0100
schrieb Ulli Horlacher <framstag@rus.uni-stuttgart.de>:

> I have vmware and virtualbox VMs on btrfs SSD.
> 
> I read in
> https://btrfs.wiki.kernel.org/index.php/SysadminGuide#When_To_Make_Subvolumes
> 
>      certain types of data (databases, VM images and similar
> typically big files that are randomly written internally) may require
> CoW to be disabled for them.  So for example such areas could be
> placed in a subvolume, that is always mounted with the option
> "nodatacow".
> 
> Does this apply to SSDs, too?

As a side note: I don't think you can use "nodatacow" just for one
subvolume while the other subvolumes of the same btrfs are mounted
different. The wiki is just wrong here.

The list of possible mount options in the wiki explicitly lists
"nodatacow" as not working per subvolume - just globally for the whole
fs.

-- 
Regards,
Kai

Replies to list-only preferred.

