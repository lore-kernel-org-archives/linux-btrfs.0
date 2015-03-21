Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34278 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbCUS0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 14:26:41 -0400
Received: by iedfl3 with SMTP id fl3so12863927ied.1
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2015 11:26:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+4EQ5fmYejgGf5yN0Qw7O9O43jPb6-f-RCVGXRopjA6-p2_2Q@mail.gmail.com>
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
	<20150321232225.5f7e997e@natsu>
	<CA+4EQ5fmYejgGf5yN0Qw7O9O43jPb6-f-RCVGXRopjA6-p2_2Q@mail.gmail.com>
Date: Sat, 21 Mar 2015 19:26:41 +0100
Message-ID: <CA+4EQ5cO3hR17RYTdHB8ZYn+OQHd9fEnyTWLgNPNcqRnzkRNOQ@mail.gmail.com>
Subject: Re: New tool to recursive compress / decompress of files
From: Petr Bena <benapetr@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a dozen of cases where you want to just compress some folders
in your system, but you don't want to compress whole device, would you
create a subvolume for each of them?

On Sat, Mar 21, 2015 at 7:25 PM, Petr Bena <benapetr@gmail.com> wrote:
> Ok, but what if I am just a non-root user who want to transparently
> compress some of their data? What if I am a root user who does just
> want to compress some large folder transparently and doesn't want to
> mess up with subvolumes?
>
> I know that from sysadmin point of view, there is no need for this,
> but from regular user point of view, who have btrfs on their laptop,
> this could make life easier.
>
> On Sat, Mar 21, 2015 at 7:22 PM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Sat, 21 Mar 2015 18:56:12 +0100
>> Petr Bena <benapetr@gmail.com> wrote:
>>
>>> unlike NTFS, compressing files in btrfs is not so simple
>>
>> There shouldn't be any need to micro-manage compression on Btrfs on a
>> per-folder or per-file basis. Just mount the whole volume as compress=[method]
>> (but not compress-force), there shouldn't be any downside, on the contrary,
>> with the current ratio of CPU core count and their performance to disk I/O
>> speed, you are likely to even see a speed-up. Also files which are detected to
>> be incompressible are automatically skipped from compression (at least that's
>> what it tries to do by design).
>>
>> If you want higher performance and less fragmentation on certain files/folders,
>> you are supposed to set them NOCOW, at which point the compression is also
>> automatically disabled.
>>
>> --
>> With respect,
>> Roman
