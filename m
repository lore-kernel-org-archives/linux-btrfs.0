Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:55643 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3AHCDd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 21:03:33 -0500
Received: by mail-we0-f179.google.com with SMTP id r6so10477080wey.38
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 18:03:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EB0DE0.9040500@redhat.com>
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com>
	<CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
	<20130107153132.GH20089@twin.jikos.cz>
	<50EB0DE0.9040500@redhat.com>
Date: Tue, 8 Jan 2013 07:33:32 +0530
Message-ID: <CANT588uuWs4d_uRnpfVXdp96AwVgE1qhY984UpikgR-Sv9+31w@mail.gmail.com>
Subject: Re: Open for contribution towards xfstests for btrfs
From: Kiran Patil <kirantpatil@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>>
>> By any chance, are these the same people behind
>> http://sourceforge.net/projects/btrfstest/ ?

No, they are not the same people.

>
> If so, you might want to consider that
>
> http://www.tuxera.com/community/posix-test-suite/
>
> probably already covers some of the tests that "btrfstest" is
> (re)writing.  i.e.:
>
> +/* Creating Link on non-existing prefix path should return ENOTDIR
>
> and
>
> +/* Creating link on ENAMETOOLONG if either file name exceeds maximum characters
>
> are almost certainly covered in the above posix test suite.
>
> FWIW, that testsuite has a few failures on btrfs (not all unique to btrfs, IIRC):

Sure, we will look at them.

> Test Summary Report
> -------------------
> /root/pjd-fstest/pjd-fstest-20090130-RC/tests/chown/00.t   (Wstat: 0 Tests: 171 Failed: 6)
>   Failed tests:  84, 88, 141, 145, 149, 153
> /root/pjd-fstest/pjd-fstest-20090130-RC/tests/truncate/00.t (Wstat: 0 Tests: 21 Failed: 1)
>   Failed test:  15
> /root/pjd-fstest/pjd-fstest-20090130-RC/tests/xacl/00.t    (Wstat: 0 Tests: 45 Failed: 1)
>   Failed test:  45
>
> -Eric
>
Thanks,
Kiran.
