Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:32921 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbDASUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 14:20:32 -0400
Received: by iebmp1 with SMTP id mp1so43318163ieb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 11:20:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCL7L=U3jfV1oU9th+siGb8qcdqU4WHUOCOBnzo=N5MCGA@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
	<CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
	<CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
	<CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
	<CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com>
	<CAJCQCtShxpMC10QXJ8=rQCa2SaZ56d4kwH2riL4mEChCC-WvHg@mail.gmail.com>
	<CACPiFCL7L=U3jfV1oU9th+siGb8qcdqU4WHUOCOBnzo=N5MCGA@mail.gmail.com>
Date: Wed, 1 Apr 2015 12:20:31 -0600
Message-ID: <CAJCQCtTqDRwrvZHKMgx0hHjNnZh9pcen9xcw1=PV2nLMiU_jag@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 12:16 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> On Wed, Apr 1, 2015 at 2:04 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> When I had this same btrfs check error, it was the exact inode number
>> and same /etc/shadow file. I didn't diff the two shadow files, but I
>
> That's too bizarre for words. Two folks, on two different systems,
> getting btrfs problems on similar kernels on the exact same filepath.
> In my case, the file was last frobbed by yum/rpm. Do we have a strange
> interaction between a kernel regression and yum/rpm rubbing the
> filesystem the wrong way?

No idea, but it happened to me more than once, same inode number, same file.



> BTW, I did not change/touch the file at all. My only "fix" action was
> the btrfs check --repair mentioned earlier.

That won't fix it. Once errors 400 appears, at this point you have to
replace the affected file.





-- 
Chris Murphy
