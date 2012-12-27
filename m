Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:36684 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2L0O3j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 09:29:39 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121227142938.FNMZ17456.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 27 Dec 2012 09:29:38 -0500
Message-ID: <50DC5B51.9060506@czarc.net>
Date: Thu, 27 Dec 2012 09:29:37 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Another novice question & comment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, this is from inside a shell.  I have a btrfs volume or a btrfs 
subvolume on some arbitrary mount mount.  Is there some way to tell if 
it is a btrfs volume or a btrfs subvolume that is mounted?

Comment:  It sure would be nice if the btrfs man page corresponded 
better to the btrfs code.  Example, the man page says there is a "btrfs 
subvolume show" command.  The code disagrees and so does "btrfs --help"

Gene
