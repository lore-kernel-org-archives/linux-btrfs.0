Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63024 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533Ab3DPWuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 18:50:17 -0400
Received: by mail-ee0-f41.google.com with SMTP id c1so484239eek.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 15:50:15 -0700 (PDT)
From: Marek Otahal <markotahal@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
Date: Wed, 17 Apr 2013 00:50:04 +0200
Message-ID: <2164102.vSxPIH87oQ@beruska>
In-Reply-To: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark, 

could you compare (appart from online/offline) your implementation to LiuBo's work?, appeared on ML a while ago: 
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23656.html

It would be interesting if the two approaches could share some code, and also confirmation that using one technique does not 
disregard using the other in future. 

Best wishes, 
Mark

On Tuesday 16 April 2013 15:15:31 Mark Fasheh wrote:
> Hi,
>  
> The following series of patches implements in btrfs an ioctl to do
> offline deduplication of file extents.
> 
> To be clear, "offline" in this sense means that the file system is
> mounted and running, but the dedupe is not done during file writes,
> but after the fact when some userspace software initiates a dedupe.
> 
> The primary patch is loosely based off of one sent by Josef Bacik back
> in January, 2011.
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8508
> 
> I've made significant updates and changes from the original. In
> particular the structure passed is more fleshed out, this series has a
> high degree of code sharing between itself and the clone code, and the
> locking has been updated.
> 
...
> 
> Code review is very much appreciated. Thanks,
>      --Mark
-- 

Marek Otahal :o)
