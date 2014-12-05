Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rx0ar-terminal-systems-international.ed.BIGPIPEINC.COM ([208.118.95.38]:50884
	"EHLO mail.terminalsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbaLEShr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 13:37:47 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.terminalsystems.com (Postfix) with ESMTP id 49FAB40671
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Dec 2014 12:27:51 -0600 (CST)
Received: from mail.terminalsystems.com ([127.0.0.1])
	by localhost (tsiblade9.terminalsystems.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bEpSeYygFq2F for <linux-btrfs@vger.kernel.org>;
	Fri,  5 Dec 2014 12:27:45 -0600 (CST)
Received: from [192.168.7.202] (unknown [192.168.7.202])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jwest)
	by mail.terminalsystems.com (Postfix) with ESMTPSA id BA41B40670
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Dec 2014 12:27:45 -0600 (CST)
Message-ID: <5481F91B.6090700@terminalsystems.com>
Date: Fri, 05 Dec 2014 12:27:39 -0600
From: James West <james@terminalsystems.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Possibility to have a "transient" snapshot?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just a random idea that popped through my mind while I was 
looking into hardening a filesystem against damage, might be 
impractical, but the idea seems promising, and well suited to a snapshot 
file system.

I'm sure some creative shell scripting could do something like this 
already, but I was more looking for something more bulletproof.

General idea would be to have a transient snapshot (optional quota 
support possibility here) on top of a base snapshot (possibly readonly). 
On system start/restart (whether clean or dirty), the transient snapshot 
would be flushed, and the system would restart the snapshot, basically 
restarting from the base snapshot. If desired, the transient snapshot 
could be promoted to a regular snapshot (say after a software upgrade). 
If desired, a different base snapshot could be selected (although I'm 
sure the file system would have to be restarted to do this)

 From a caching perspective, this could make a noticable performance 
difference, since if you're running in a transient snapshot, the file 
system can be _extremely_ lazy about committing changes to disk.

For the optional quote support I mentioned, on an unattended box, if the 
quota gets exceeded, a system reboot would probably fully correct the 
system. (Presumably a log file got out of control in that situation).
