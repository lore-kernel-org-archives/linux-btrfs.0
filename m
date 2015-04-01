Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35858 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbDAUVT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 16:21:19 -0400
Received: by igbud6 with SMTP id ud6so59064963igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 13:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTU=fu5NVGPhw6nqyULUWVhhsJDfXJUs5rX-jWO0TC4yg@mail.gmail.com>
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
Date: Wed, 1 Apr 2015 14:21:19 -0600
Message-ID: <CAJCQCtR+QkVrsGsKHKCqVmGgW5ww6g0mgsTjuqd7iScxZaD75g@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
Cc: Martin Langhoff <martin.langhoff@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Related bugs:

https://bugzilla.kernel.org/show_bug.cgi?id=68411
https://bugzilla.redhat.com/show_bug.cgi?id=1037963

The RHBZ one also mentioned the shadow file.

Anyway, it seems to be a somewhat known problem, but it's just not
known yet what causes it.

Chris Murphy
