Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61394 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaBKUuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 15:50:13 -0500
Received: by mail-ob0-f181.google.com with SMTP id va2so9445694obc.40
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 12:50:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <16006080.zeFsK4Kcpx@merkaba>
References: <16006080.zeFsK4Kcpx@merkaba>
Date: Tue, 11 Feb 2014 15:50:12 -0500
Message-ID: <CAAVQaYBurkq_OdE7K0vEoNhToFHYRQo5Y4bJE_Cx5J-awDh1ow@mail.gmail.com>
Subject: Re: [3.14-rc1] BUG: soft lockup - CPU#1 stuck for 22s with 255 GiB
 BTRFS with only 6 GiB free
From: Dave <dave@thekilempire.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 11, 2014 at 10:36 AM, Martin Steigerwald
<Martin@lichtvoll.de> wrote:
> Today I started getting those on 3.14-rc. One core as displayed as 100%
> system CPU. I rebooted cause the system didn´t respond consistently to
> user input anymore.

Does 3.14-rc1 have Joseph's delayed refs throttling code?  I had two
separate machines that exhibited similar symptoms.  Chris's for-linus
branch has a fix for this which solved my problems:
https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-linus&id=27a377db745ed4d11b3b9b340756857cb8dde07f
-- 
-=[dave]=-

Entropy isn't what it used to be.
