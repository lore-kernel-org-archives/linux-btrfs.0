Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37217 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3DLMfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 08:35:05 -0400
Received: by mail-ee0-f43.google.com with SMTP id e50so1222620eek.30
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2013 05:35:02 -0700 (PDT)
Message-ID: <5167FF73.2090201@statystyka.net>
Date: Fri, 12 Apr 2013 14:34:59 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is it currently possible to remount subvolume (not the whole filesystem)
 with nodatacow?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If so, please tell me, what is the first confirmed kernel version, which 
supports this. Or at least, is it available on Kernel 3.5.

I know, that it is possible to assign nodatacow attribute to files with 
"chattr +C <filename>", if the file has zero length.

Thank you
-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

