Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:47203 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2L0TOp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 14:14:45 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121227191444.SPAH6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 27 Dec 2012 14:14:44 -0500
Message-ID: <50DC9E23.5070009@czarc.net>
Date: Thu, 27 Dec 2012 14:14:43 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: Another novice question & comment
References: <50DC5B51.9060506@czarc.net> <0290535D-CBF3-4059-AEF8-3E3A64ABC223@colorremedies.com>
In-Reply-To: <0290535D-CBF3-4059-AEF8-3E3A64ABC223@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2012 11:07 AM, Chris Murphy wrote:
> On Dec 27, 2012, at 7:29 AM, Gene Czarcinski <gene@czarc.net> wrote:
>
>> OK, this is from inside a shell.  I have a btrfs volume or a btrfs subvolume on some arbitrary mount mount.  Is there some way to tell if it is a btrfs volume or a btrfs subvolume that is mounted?
> cat /proc/self/mountinfo | grep btrfs
>
> That will show you what subvol is mounted and where, subvol is the 4th column, mountpoint is the fifth.
Thank you.  That is just what I needed.

Gene
