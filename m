Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9613 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3KGItb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 03:49:31 -0500
Message-ID: <527B541D.5000101@giantdisaster.de>
Date: Thu, 07 Nov 2013 09:49:33 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Bartosz Kulicki <bartosz.kulicki@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10
 to 3.12
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com> <CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
In-Reply-To: <CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 6 Nov 2013 21:53:25 +0000, Bartosz Kulicki wrote:
> As per subject. Seems UUID tree creation failed after upgrade. I could
> not mount filesystem under 3.12. Going back to 3.8.10 allowed me to
> mount fs but I could no longer perform any deletes, writes etc.
> 
> I've opened a bug report here.
> https://bugzilla.kernel.org/show_bug.cgi?id=64461
> 
> I've included link to image captured with btrfs-image.
> 
> Please CC me if further information is needed as I'm not subscribed to
> the mailing list.
> 

ENOSPC means you're out of disk space. A copy-on-write filesystem needs
disk space for delete operations, that's not a bug.

What does 'btrfs fi df /mountpoint' say?
How much disk space do you have, how much is allocated?

And try the procedure that is described in the wiki:

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space


