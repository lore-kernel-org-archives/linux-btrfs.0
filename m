Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from locke.effortlessis.com ([208.53.66.14]:58749 "EHLO
	locke.effortlessis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaDDQuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 12:50:08 -0400
Received: from tesla.schoolpathways.com (173-166-236-97-sacramento.hfc.comcastbusiness.net [173.166.236.97])
	by locke.effortlessis.com (Postfix) with ESMTPSA id 5E12444FBD
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Apr 2014 16:50:06 +0000 (UTC)
Message-ID: <533EE2BD.7060608@benjamindsmith.com>
Date: Fri, 04 Apr 2014 09:50:05 -0700
From: Lists <lists@benjamindsmith.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: BTRFS send/receive limitations
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I read recently that you can't send/receive concurrent streams on the 
same filesystem, which begs the question of what is meant by a 
"filesystem". Is that to say that you can't send/receive snapshots on 
different subvolumes to the same "root filesystem"? Or that you can't 
send/receive multiple snapshots on the same subvolume? Can you 
send/receive a snapshot or subvolume to the same root filesystem?

-Ben
