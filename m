Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34448 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbbDASRL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 14:17:11 -0400
Received: by wixo5 with SMTP id o5so35100670wix.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 11:17:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtShxpMC10QXJ8=rQCa2SaZ56d4kwH2riL4mEChCC-WvHg@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
 <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
 <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
 <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
 <CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
 <CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com> <CAJCQCtShxpMC10QXJ8=rQCa2SaZ56d4kwH2riL4mEChCC-WvHg@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 14:16:48 -0400
Message-ID: <CACPiFCL7L=U3jfV1oU9th+siGb8qcdqU4WHUOCOBnzo=N5MCGA@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 2:04 PM, Chris Murphy <lists@colorremedies.com> wrote:
> When I had this same btrfs check error, it was the exact inode number
> and same /etc/shadow file. I didn't diff the two shadow files, but I

That's too bizarre for words. Two folks, on two different systems,
getting btrfs problems on similar kernels on the exact same filepath.
In my case, the file was last frobbed by yum/rpm. Do we have a strange
interaction between a kernel regression and yum/rpm rubbing the
filesystem the wrong way?

BTW, I did not change/touch the file at all. My only "fix" action was
the btrfs check --repair mentioned earlier. Right now, on the booted
system I did

# uname -a
Linux tp-martin.remote-learner.net 3.18.9-200.fc21.x86_64 #1 SMP Mon
Mar 9 15:10:50 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
# btrfs scrub start -BrR   /
scrub done for 94637b35-a294-4be2-aa47-82c52d6d53ef
        scrub started at Wed Apr  1 13:46:20 2015 and finished after 266 seconds
        data_extents_scrubbed: 344155
        tree_extents_scrubbed: 58048
        data_bytes_scrubbed: 11896840192
        tree_bytes_scrubbed: 951058432
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 20268
        csum_discards: 254459
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 23928504320

cheers,



m
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
