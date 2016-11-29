Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51245 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753460AbcK2FGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 00:06:31 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cBacb-0000Du-At
        for linux-btrfs@vger.kernel.org; Tue, 29 Nov 2016 06:06:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount option nodatacow for VMs on SSD?
Date: Tue, 29 Nov 2016 05:06:17 +0000 (UTC)
Message-ID: <pan$8ecb6$a69408d3$b47213c2$9bfeddf6@cox.net>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
        <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
        <20161128003829.GD15348@rus.uni-stuttgart.de>
        <20161128092015.70b75dd8@jupiter.sol.kaishome.de>
        <ca646391-bd9f-49b2-bca4-8faee04fd82a@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Mon, 28 Nov 2016 12:11:49 +0100 as excerpted:

> On lunedì 28 novembre 2016 09:20:15 CET, Kai Krakow wrote:
>> You can, however, use chattr to make the subvolume root directory (that
>> one where it is mounted) nodatacow (chattr +C) _before_ placing any
>> files or directories in there. That way, newly created files and
>> directories will inherit the flag. Take note that this flag can only
>> applied to directories and empty (zero-sized) files.
> 
> Do I keep checksumming for this directory such a way?

No.  Keeping checksums current on NOCOW files is racy, and compression 
would be complex as well because rewritten data may compress more or less 
well than the original so the on-filesystem size could change, so both 
features are disabled in the presence of NOCOW, regardless of how it is 
set.

Put another way, btrfs assumes COW by default and many of its features 
depend on COW -- that's why these features don't tend to be implemented 
on conventional rewrite-in-place filesystems in the first place.  Both 
checksumming and compression are among these COW-dependent features.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

