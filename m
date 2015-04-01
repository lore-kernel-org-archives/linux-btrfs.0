Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36574 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbDAQ1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 12:27:07 -0400
Received: by wixo5 with SMTP id o5so55551106wix.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 09:27:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCKtEHdnMjKC_rCuHfAHO0CFiHN9YaY5jRfKdmu+dOYh+g@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
 <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
 <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
 <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com> <CACPiFCKtEHdnMjKC_rCuHfAHO0CFiHN9YaY5jRfKdmu+dOYh+g@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 12:26:46 -0400
Message-ID: <CACPiFCJc70bK1gvsryjO31EGdVXAknXzcpcM0YBr-itsc0heRw@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 12:15 PM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> Will try to capture some info from a dracut breakpoint  (I'll try
> mount). At this point this really looks like a regression.

After a couple alternating boots, the problem vanished :-/:

 - 3.18.7-200.fc21 - success
 - 3.18.9-200.fc21 - timeout
 - 3.18.7-200.fc21 - success
 - 3.18.9-200.fc21 - timeout
 - 3.18.7-200.fc21 - success
 - 3.18.9-200.fc21 - with rd.shell rd.break=mount rd.debug --> success
 - 3.18.9-200.fc21 - with no special params -- success

(all boots had rhgb and quiet params removed)

So problem is gone, yet I feel like this
https://c2.staticflickr.com/4/3438/4593531893_f67a757fa1.jpg



m
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
