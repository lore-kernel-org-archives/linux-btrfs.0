Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:50842 "EHLO
        resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935750AbcJRTHD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 15:07:03 -0400
Received: from calvin.localdomain ([10.0.0.8])
        by beta.localdomain with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <twalberg@comcast.net>)
        id 1bwZj1-0002HD-SW
        for linux-btrfs@vger.kernel.org; Tue, 18 Oct 2016 14:06:59 -0500
Received: from tew by calvin.localdomain with local (Exim 4.84_2)
        (envelope-from <tew@calvin.localdomain>)
        id 1bwZj1-0006Sl-Nw
        for linux-btrfs@vger.kernel.org; Tue, 18 Oct 2016 14:06:59 -0500
Date: Tue, 18 Oct 2016 14:06:59 -0500
From: Tim Walberg <twalberg@comcast.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: question re: trim in btrfs
Message-ID: <20161018190659.GC5559@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
References: <20161018174238.GB5559@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161018174238.GB5559@comcast.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Forgot to mention - this was on a rather crusty 4.2.6 kernel. Just upgraded to 4.8.1
and the issue appears to have been resolved...

On 10/18/2016 12:42 -0500, Walberg, Tim wrote:
>>	Unless I'm misinterpreting something it appears that maybe btrfs doesn't pass
>>	fstrim commands down to the underlying drives when being used in a RAID-1 config.
>>	
>>	I have this output from a small script I wrote to run at boot time (and also via
>>	cron.weekly), rather than using continous trim in the boot options:
>>	
>>	# cat /var/log/trim.log
>>	Thu Oct 13 07:40:07 CDT 2016
>>	/boot: 454 MiB (476062720 bytes) trimmed
>>	
>>	Thu Oct 13 07:40:08 CDT 2016
>>	/: 8.9 GiB (9585152000 bytes) trimmed
>>	
>>	Thu Oct 13 07:40:22 CDT 2016
>>	/btrfs/0: 0 B (0 bytes) trimmed
>>	
>>	/boot and / are mdraid RAID 1 on partitions 1 and 3 of two Samsung 850 Pro SSDs.
>>	/btrfs/0 is a btrfs-raid RAID 1 of partition 4 on the same two drives. The btrfs
>>	case does not seem to accomplish anything. By comparison, I have the same drive
>>	in my laptop, but just a single one, and the non-btrfs-raid-1 file system on one
>>	of its partitions does run fstrim successfully.
>>	
>>	This is quite possibly a known limitation, but I didn't find anything about it
>>	through some quick searching. Maybe I didn't dive deep enough...
>>	
>>	-- 
>>	twalberg@gmail.com, twalberg@comcast.net
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
End of included message



-- 
twalberg@gmail.com, twalberg@comcast.net
