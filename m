Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob09.myregisteredsite.com ([209.17.115.47]:60226 "EHLO
	atl4mhob09.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbaDGFYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 01:24:17 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.115])
	by atl4mhob09.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s375OFfd023271
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Apr 2014 01:24:15 -0400
Message-ID: <534236AF.4020204@chinilu.com>
Date: Sun, 06 Apr 2014 22:25:03 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Possible application issue ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am seeming to have an issue with a specific application.  I just 
installed "Recoll", a really nice desktop search tool.  And the 
following day whenever my backup program would attempt to run, my 
computer simply stopped dead in its tracks and I was forced to do a hard 
reboot to get it back.  So tonight I have been trying to shag out the 
problem.  And the problem goes like this.  Whenever I try to defrag the 
Recoll data files, I get a string of weird messages poring out from the 
btrfs defrag program itself and flashing messages on the screen 
regarding some sort of CPU failure problem for both cpus.  As soon as I 
removed the ".recoll" data directory from the path, everything got OK.  
Does anyone know what might be going on here or should I run the thing 
and try to trap the output and post it and/or send a copy of the data 
files in question?
