Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:47953 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2LFFYC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2012 00:24:02 -0500
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by m53-178.qiye.163.com (HMail) with ESMTPA id 1EE5012282FC
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2012 13:15:32 +0800 (CST)
Received: by mail-la0-f46.google.com with SMTP id p5so4965461lag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2012 21:15:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
References: <CACR_K2s2NXFJfNknzJLLnQGK6=Sz+6Abs8y7kJfxxynUUaF+cA@mail.gmail.com>
From: Rock Lee <zimilo@code-trick.com>
Date: Thu, 6 Dec 2012 13:14:50 +0800
Message-ID: <CAMRmmpLdvfcDXFpN9R7H7ObAcqvhO3gAt_yO8D0Wz5kgLXUiTg@mail.gmail.com>
Subject: Re: Question about btrfs snapshot delay and rm -rf delay
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe you can use systemtap to track what's going on.

2012/12/6 Sylvain Alain <d2racing911@gmail.com>:
> Hi everyone, I'm running btrfs since octobre 2012 and I would like to
> understand 2 behavior that I noticed.
>
> 1. When I delete a big directory, sometimes it can hang my box for 1
> minutes or so, it seems that's the btrfs lock my SSD.
>
> 2. Sometimes when I run btrfs subvolume snapshot @root @backup, it can
> run the command in a split seconde, and sometimes the command can last
> for about 3 minutes.
>
> My SSD installation is about 3.1 gigs of data.
>
> My main question is this : Is there any log about the btrfs filesystem
> that I can look at to see why and what is going on.
>
> I'm running the vanilla-souces 3.6.9. with btrfs-prog 0.20-rc1
>
> For more detail about my box  :
> https://gentooquebec.org/gwiki/index.php/Utilisateur:D2_racing
>
> Thanks :P
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

