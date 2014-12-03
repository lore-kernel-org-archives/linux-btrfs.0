Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:36672 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLCCfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 21:35:30 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so9645378qae.41
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 18:35:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547E5544.7090907@jp.fujitsu.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <547D663A.3020201@jp.fujitsu.com> <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
 <547E5544.7090907@jp.fujitsu.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Wed, 3 Dec 2014 08:05:08 +0530
Message-ID: <CAH-HCWXBEkR3uVr7SPoiuYx2bSbrWQvvE=BWDw-5b+j7HES8+g@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 3, 2014 at 5:41 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
> 2. You delete /snap by "snapper delete" command by mistake.
>    Then snapper takes a "pre" snapshot just before deleting
>    /snap.
> 3. Now /snap is deleted, however, a "pre" snapshot which is
>    the same as /snap before deleting, is still alive.
>
> I don't know how Btrfs itself undo the deletion of a snapshot.
> It works if you manages snapshots not by btrfs directly,
> but by snapper.
>
> If I misunderstanding something, sorry for noise.

No nothing misunderstood. Excellent illustration. So using snapper is
sorta like using the higher-level trash instead of lower-level rm, so
that even after we "delete", it's still available...

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
