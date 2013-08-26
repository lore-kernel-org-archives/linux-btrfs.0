Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:5641 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751725Ab3HZTJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 15:09:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: snapshot space available
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5FA1D778-230D-4EB5-B7C9-537ABFFC9EAA@colorremedies.com>
Date: Mon, 26 Aug 2013 13:09:45 -0600
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Message-Id: <708D6B3A-EF66-4978-A856-7D01B2687083@colorremedies.com>
References: <201308262335.25871.russell@coker.com.au> <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com> <5FA1D778-230D-4EB5-B7C9-537ABFFC9EAA@colorremedies.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 9:27 AM, Chris Murphy <lists@colorremedies.com> wrote:

> I haven't tried doing a partial balance, deleting the extra device, then finishing the balance.

Btrfs FAQ suggests a partial balance for this situation. So it's worth a try before adding a device.

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space


Chris Murphy

