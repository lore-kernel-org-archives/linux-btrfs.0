Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-relay2.uniserve.net ([216.210.109.135]:39627 "EHLO
	smtp-relay2.uniserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbBVBPC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Feb 2015 20:15:02 -0500
Received: from webapp1.uniserve.ca ([204.239.42.114])
	by smtp-relay2.uniserve.net with esmtp (Exim 4.72)
	(envelope-from <geek@uniserve.com>)
	id 1YPKwV-0002BZ-0n
	for linux-btrfs@vger.kernel.org; Sat, 21 Feb 2015 17:02:43 -0800
Message-ID: <20150221170242.97157f5dfm60oib6@webmail.uniserve.com>
Date: Sat, 21 Feb 2015 17:02:42 -0800
From: Dave Stevens <geek@uniserve.com>
To: linux-btrfs@vger.kernel.org
Subject: OT raid-1 from raid-10?
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there's a better list please say so.

I have a raid-10 array with two dirty drives and (according to the  
kernel) not enough mirrors to repair the raid-10. But I think drives  
sda and sdb are mirrored and maybe I could read the data off them if I  
changed the fs type from linux raid autodetect to ext3. is that  
reasonable?

D

-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





