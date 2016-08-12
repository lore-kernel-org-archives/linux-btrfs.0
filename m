Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34377 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbcHLTA1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 15:00:27 -0400
Received: by mail-qk0-f194.google.com with SMTP id x67so2582935qke.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 12:00:27 -0700 (PDT)
Message-ID: <1471028417.16857.12.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Fri, 12 Aug 2016 16:00:17 -0300
In-Reply-To: <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
	 <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em Sex, 2016-08-12 às 12:02 -0600, Chris Murphy escreveu:
> Tons of unallocated space. What kernel messages do you get for the
> enospc? It sounds like this will be one of the mystery -28 error file
> systems. So far as I recall the only work around is recreating the
> file system. There are two additional things you can try: mount with
> enospc_debug mount option and see if you can gather more information
> about the problem. Or try a 4.8rc1 kernel which as a large number of
> enospc changes.
> 
> 

Unfortunately no log was written due to the lack of space :)
Next time it happens, I will take a screenshot of the message. Do you
think that if I reinstall my openSUSE it will be fixed?

Regards,
Ronan Arraes
