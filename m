Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57647 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaFXMPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 08:15:40 -0400
Received: by mail-ie0-f169.google.com with SMTP id at1so153378iec.28
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 05:15:39 -0700 (PDT)
Message-ID: <53A96BEA.40800@gmail.com>
Date: Tue, 24 Jun 2014 07:15:38 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Removing file = quota exceded
References: <53A62E89.6040900@gmail.com> <53A7069E.5010003@fb.com>	<53A718CE.9030701@gmail.com>	<pan$d6c28$7dab67c8$466f1e49$ff456a63@cox.net> <pan$ce26c$9607f21a$b0e5b759$ed8f68f3@cox.net>
In-Reply-To: <pan$ce26c$9607f21a$b0e5b759$ed8f68f3@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I do recall that the issue was more specifically happening with larger
files.
In another scenario i had two files, one small or even empty, and one
large that filled the
subvolume quota. If i recall correctly, I was able to remove the smaller
file without exceeding
the quota limit, and then remove the larger file. However, removing the
larger file resulted
in the quota exceeded error. The behavior you describe with small files
makes this case make
more sense.

Likewise, I found that handling an unlink with a full subvolume qgruop
(EDQUOT) the same way as a full file system (ENOSPC) resolved the issue.

-Kevin

On 06/24/2014 12:31 AM, Duncan wrote:
> Duncan posted on Mon, 23 Jun 2014 01:53:45 +0000 as excerpted:
>
>> However, because btrfs stores very small files (generally something
>> under 16 MiB, the precise size depends on filesystem parameters)
>> entirely within metadata
> Hmm.  Should be under 16 KiB I believe, not 16 MiB.
>

