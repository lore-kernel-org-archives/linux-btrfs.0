Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33198 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbbDAUOu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 16:14:50 -0400
Received: by ignm3 with SMTP id m3so37850360ign.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 13:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCKQBcNepbEZMZUpqkhiv=SsfyS+Y_35SU-zpT01+gOr9g@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
	<CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
	<CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
	<CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
	<CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com>
	<CAJCQCtShxpMC10QXJ8=rQCa2SaZ56d4kwH2riL4mEChCC-WvHg@mail.gmail.com>
	<CACPiFCL7L=U3jfV1oU9th+siGb8qcdqU4WHUOCOBnzo=N5MCGA@mail.gmail.com>
	<CAJCQCtTqDRwrvZHKMgx0hHjNnZh9pcen9xcw1=PV2nLMiU_jag@mail.gmail.com>
	<CACPiFCLE0T208BPhkzCRpwfSz7gRpZD=9eCdrZp1mTRXzJsqJg@mail.gmail.com>
	<CAJCQCtR+3JiC4Vsb0gn19xe_Kd8atYUn99BBinfZn=4W7a7xDg@mail.gmail.com>
	<CACPiFCKQBcNepbEZMZUpqkhiv=SsfyS+Y_35SU-zpT01+gOr9g@mail.gmail.com>
Date: Wed, 1 Apr 2015 14:14:49 -0600
Message-ID: <CAJCQCtTU=fu5NVGPhw6nqyULUWVhhsJDfXJUs5rX-jWO0TC4yg@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 1:23 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> On Wed, Apr 1, 2015 at 2:54 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Re-run the btrfs check. The error is still there even after a --repair.
>
> Bingo! You are right the error persists.
>
> It has no effect on my use of the system right now. Is anyone
> interested in debugging this further?

400 errors, nbytes wrong, isn't repaired by current btrfs check
https://bugzilla.kernel.org/show_bug.cgi?id=90071

What's interesting in that bug report that I'd forgotten about?

># btrfs inspect inode 804 /mnt/root
>/mnt/root/etc/shadow-

Different inode number, but the shadow file is affected. In every
single case I've had now (about 1/2 dozen) with this errors 400
message, it's involved the shadow file. I have no idea what's going on
between Btrfs and the shadow file, but something seems to be. Or it's
quite a coincidence.




-- 
Chris Murphy
