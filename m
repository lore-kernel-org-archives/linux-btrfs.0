Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:33969 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2LLSfB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 13:35:01 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121212182241.YDWK6475.eastrmfepo202.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 12 Dec 2012 13:22:41 -0500
Message-ID: <50C8CB70.4060901@czarc.net>
Date: Wed, 12 Dec 2012 13:22:40 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: subvolume show
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was looking through some of the archives and notice a patch submitted 
to implement:
       btrfs  subvolume  show  <path-to-subvolume>
command.

I also noticed that is does not appear to be in the git.

This looks like a useful capability.  I was trying to find out what the 
UUID was for a newly created subvolume and have not found out how to do 
that.

Gene
