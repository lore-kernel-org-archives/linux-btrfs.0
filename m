Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36130 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbbCQXQH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 19:16:07 -0400
Received: by ykcn8 with SMTP id n8so9967595ykc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 16:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5508B245.5080607@inwind.it>
References: <trinity-2997a6a9-13e0-4df6-ae13-0d944bd2f0b1-1426358188246@3capp-gmx-bs46>
	<C879D0AA-018D-4C52-94F8-37D322F8DCD4@gmail.com>
	<5508B245.5080607@inwind.it>
Date: Tue, 17 Mar 2015 17:16:06 -0600
Message-ID: <CAJCQCtRxOZTS=2KGQ6cY24NN3nb7gmX9WcG6iK4hxkCE4a5jhQ@mail.gmail.com>
Subject: Re: Is it safe or useful to use NOCOW flag and autodefrag mount
 option at same time?
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 5:01 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> If I read correctly, autodefrag disables the NOcow behavior. This to me doesn't seem be "work well"; these are two incompatibles features: enabling autodefrag disables the nocow behavior on all files.
> Do I understood correctly ?

I'm not sure whether autodefrag works on large VM files anyway. I
thought it was more targeted for things like log files and journals.



-- 
Chris Murphy
