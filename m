Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:60682 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2LUSRA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 13:17:00 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20121221181659.TNXO17456.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 21 Dec 2012 13:16:59 -0500
Message-ID: <50D4A79B.6010008@czarc.net>
Date: Fri, 21 Dec 2012 13:16:59 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: add, remove; how about merge?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am new at this btrfs stuff!

As I understand it, you can add a physical disk or partition and have 
data spread into the new space.  You can also move data off a disk or 
partition and then remove it.

Has any though  been given to being able merge to existing (separate) 
btrfs "volumes" into a single volume?

Alternatively, how about at tool for transfering a subvolume from one 
pool to another?  I tried using fsarchiver but that did not work out too 
well.

Gene
