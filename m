Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34108 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbeA2NFr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 08:05:47 -0500
Received: by mail-it0-f68.google.com with SMTP id m11so31009450iti.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 05:05:46 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id x87sm5977614ita.32.2018.01.29.05.05.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jan 2018 05:05:45 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6804d30d-53ff-403f-1eac-ac5da01509f7@gmail.com>
Date: Mon, 29 Jan 2018 08:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-29 06:24, Adam Borowski wrote:
> On Mon, Jan 29, 2018 at 09:54:04AM +0100, Tomasz Pala wrote:
>> it is a btrfs drawback that doesn't provice anything else except for this
>> IOCTL with it's logic
> 
> How can it provide you with something it doesn't yet have?  If you want the
> information, call mount().  And as others in this thread have mentioned,
> what, pray tell, would you want to know "would a mount succeed?" for if you
> don't want to mount?
And more importantly, WHY THE HELL DO YOU _WANT_ A TOCTOU RACE CONDITION 
INVOLVED?

Seriously, _THERE IS A RACE CONDITION IN SYSTEMD'S CURRENT HANDLING OF 
THIS_.  It's functionally no different than prefacing an attempt to send 
a signal to a process by checking if the process exists, or trying to 
see if some other process is using a file that might be locked by 
scanning /proc instead of just trying to lock the file yourself, or 
scheduling something to check if a RAID array is out of sync before even 
trying to start a scrub.  No sane programmer would do any of that 
(although a lot of rather poorly educated sysadmins do the third), 
because _IT'S NOT RELIABLE_.  The process you're trying to send a signal 
to might disappear after checking for it (or worse, might be a different 
process), the file might get locked by something with a low PID while 
you're busy scanning /proc, or the array could completely die right 
after you check if it's OK.
