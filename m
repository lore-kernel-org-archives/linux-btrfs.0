Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a.glodns.net ([196.220.48.58]:49538 "EHLO fw10a.glodns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2L0MKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 07:10:08 -0500
Received: from localhost (unknown [127.0.0.1])
	by fw10a.glodns.net (Postfix) with ESMTP id 3F7BC250017
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 11:59:13 +0000 (UTC)
Received: from fw10a.glodns.net ([196.220.48.58])
	by localhost (fw10a.glodns.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1A+DFzoVOfkS for <linux-btrfs@vger.kernel.org>;
	Thu, 27 Dec 2012 13:59:07 +0200 (SAST)
Received: from control.glodns.net (unknown [196.220.42.40])
	by fw10a.glodns.net (Postfix) with ESMTP id 8930725000A
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 13:59:07 +0200 (SAST)
Message-ID: <50DC3807.9080605@swiftspirit.co.za>
Date: Thu, 27 Dec 2012 13:59:03 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: btrfs df confusion
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I've made some updates on the wiki and I'd like a technical review for 
correctness. This particular topic is already confusing - some 
unnecessary sarcasm made it even more so:
https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

Due to the terms "used" and "allocated" in the wiki, viric in #btrfs 
made the good suggestion that we could adjust the show and df output 
with more intuitive language:

Before I git a patch together, please let me know if there are any good 
reasons why we wouldn't want to make such a change.

(13:31:29) viric: zatricky: "devid ... used" are allocated data, while 
"FS bytes used" is the sum of used bytes, isn't it?
(13:33:28) zatricky: viric: correct
(13:33:52) viric: zatricky: maybe the devid lines could be changed 
s/used/allocated/
(13:34:37) zatricky: viric: that's a good idea - would make it more 
intuitive
(13:35:29) viric: the same way, 'btrfs fi df' could change s/total/allocated
^ GMT+2 ;)

Thanks

-- 
__________
Brendan Hide
Mobile: +27 83 448 3867
Web Africa - Internet Business Solutions
http://www.webafrica.co.za/?AFF1E97

