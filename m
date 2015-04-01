Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34818 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbDATX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 15:23:29 -0400
Received: by widdi4 with SMTP id di4so56030284wid.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 12:23:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR+3JiC4Vsb0gn19xe_Kd8atYUn99BBinfZn=4W7a7xDg@mail.gmail.com>
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
 <CACPiFCLE0T208BPhkzCRpwfSz7gRpZD=9eCdrZp1mTRXzJsqJg@mail.gmail.com> <CAJCQCtR+3JiC4Vsb0gn19xe_Kd8atYUn99BBinfZn=4W7a7xDg@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 15:23:08 -0400
Message-ID: <CACPiFCKQBcNepbEZMZUpqkhiv=SsfyS+Y_35SU-zpT01+gOr9g@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 2:54 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Re-run the btrfs check. The error is still there even after a --repair.

Bingo! You are right the error persists.

It has no effect on my use of the system right now. Is anyone
interested in debugging this further?

cheers,



martin
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
