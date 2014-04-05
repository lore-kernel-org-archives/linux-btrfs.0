Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:50685 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaDEO0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 10:26:09 -0400
Received: by mail-yh0-f52.google.com with SMTP id c41so4287056yho.11
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 07:26:08 -0700 (PDT)
Received: from vfr.localnet (adsl-74-190-186-247.asm.bellsouth.net. [74.190.186.247])
        by mx.google.com with ESMTPSA id o62sm20783196yha.27.2014.04.05.07.26.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Apr 2014 07:26:07 -0700 (PDT)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 05 Apr 2014 10:26:06 -0400
Message-ID: <3745993.asvTJRMXlK@vfr>
In-Reply-To: <2692878.dRG1K49eOP@fnix>
References: <2692878.dRG1K49eOP@fnix>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4-4-14 10:02:27 Swâmi Petaramesh wrote:
> However I'm still concerned with chronic BTRFS dreadful performance
> and still find that BRTFS degrades much over time even with periodic
> defrag and "best practices" etc.

Yeah, I have experienced this, too.  I can't say what your experience
was, but mine was all about copy-on-write along with two applications:
akonadi and Web browsers.

I no longer see the slow degradation over time because I made the
following directories recursively nodatacow:

    .local/share/akonadi
    .cache/google-chrome/Default
    .cache/mozilla/firefox/ogtorq5r.default

To do that, I had to copy[*] all of the existing files in those
hierarchies after chattr +C on the directories.

Using btrfs on my home directory has been fine ever since.



______________
[*] Examining my shell history turned up this snippet from that time:

    for i in 0 1 2 3;do
    mv data_$i data_$i.t
    touch data_$i
    chattr +C data_$i
    cp data_$i.t data_$i
    rm data_$i.t
    done

I carefully walked all the directories, while none of the applications
above were running, converting all of the files to +C.  It took a
while as I remember.  :-)

-- 
Garry T. Williams

