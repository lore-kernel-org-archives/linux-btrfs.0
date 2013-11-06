Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57217 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3KFVx0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 16:53:26 -0500
Received: by mail-ob0-f169.google.com with SMTP id uz6so137623obc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 13:53:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
Date: Wed, 6 Nov 2013 21:53:25 +0000
Message-ID: <CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
Subject: Fwd: unable to delete files after kernel upgrade from 3.8.10 to 3.12
From: Bartosz Kulicki <bartosz.kulicki@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As per subject. Seems UUID tree creation failed after upgrade. I could
not mount filesystem under 3.12. Going back to 3.8.10 allowed me to
mount fs but I could no longer perform any deletes, writes etc.

I've opened a bug report here.
https://bugzilla.kernel.org/show_bug.cgi?id=64461

I've included link to image captured with btrfs-image.

Please CC me if further information is needed as I'm not subscribed to
the mailing list.

regards,
Bartosz
