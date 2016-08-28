Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36368 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752567AbcH1QP6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 12:15:58 -0400
Received: by mail-wm0-f52.google.com with SMTP id q128so49990456wma.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 09:15:58 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Re: btrfs send extremely slow (almost stuck)
Message-ID: <c7cb948d-5831-7b97-937e-c21c5335e76c@googlemail.com>
Date: Sun, 28 Aug 2016 18:15:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sorry if my Message-ID header is missing, I am not subscribed to the mailing list, 
so I reply using mail-archive)

> So a workaround would be reducing your duperemove usage and possibly 
> rewriting (for instance via defrag) the deduped files to kill the 
> multiple reflinks.  Or simply delete the additional reflinked copies, if 
> your use-case allows it.

Sadly, I need the extra space (that's why I was using duperemove in the first place)
and can not delete all duped copies. These are mainly several checkouts of different repositories
with partially common (partially large binary) content. 

> And thin down your snapshot retention if you have many snapshots per 
> subvolume.  With the geometric scaling issues, thinning to under 300 per 
> subvolume should be quite reasonable in nearly all circumstances, and 
> thinning to under 100 per subvolume may be possible and should result in 
> dramatically reduced scaling issues.

In addition, I have only ~ 5 snapshots for both those volumes, which should certainly not be too much. 


So in short, this just means btrfs send is (still) unusable
for filesystems which rely on the offline dedupe feature (in the past 'btrfs send' got broken
after dedupe which got fixed, now it is just extremely slow). 


For me, this means I have to stay with rsync backups, which are sadly incomplete since special FS attrs
like "C" for nocow are not backed up. 


Cheers and thanks for your reply, 
	Oliver
