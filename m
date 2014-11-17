Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:60508 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbaKQUc1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 15:32:27 -0500
Message-ID: <546A5B55.7090909@inwind.it>
Date: Mon, 17 Nov 2014 21:32:21 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: MegaBrutal <megabrutal@gmail.com>,
        Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Fwd: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>	<54699CC7.1050909@swiftspirit.co.za>	<546A46A5.8030603@inwind.it>	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
In-Reply-To: <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-17 20:45, MegaBrutal wrote:
> * I know I shouldn't make an LVM-snapshot of a mounted file system,
> but this is not the point.

This should be supported for the filesystem which support the freezing

See http://stackoverflow.com/questions/1940093/lvm-snapshot-of-mounted-filesystem


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
