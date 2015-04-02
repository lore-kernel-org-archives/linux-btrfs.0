Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35047 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbbDBD3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 23:29:48 -0400
Received: by igcau2 with SMTP id au2so66134268igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 20:29:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR+QkVrsGsKHKCqVmGgW5ww6g0mgsTjuqd7iScxZaD75g@mail.gmail.com>
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
	<CAJCQCtTU=fu5NVGPhw6nqyULUWVhhsJDfXJUs5rX-jWO0TC4yg@mail.gmail.com>
	<CAJCQCtR+QkVrsGsKHKCqVmGgW5ww6g0mgsTjuqd7iScxZaD75g@mail.gmail.com>
Date: Wed, 1 Apr 2015 21:29:47 -0600
Message-ID: <CAJCQCtRYWzfO-wa7HHuFoMLaLMQQdLU9o7iJxoP8m_biA1xEEA@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Whenever I have these boot problems, I'm noticing that sometimes the
device, /dev/sda5, is showing up with lsblk (libblkid) as
/dev/block/8:5 while everything else (not-Btrfs) on that device shows
up as /dev/sdaX. Does anyone know what that might mean?


Chris Murphy
