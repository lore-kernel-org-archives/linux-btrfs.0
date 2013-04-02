Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:46942 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3DBX32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 19:29:28 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so906026lab.33
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 16:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
References: <CAFWF=ak8pDRocvUgWuTHK+6SCOoCiuNAbhY_FNwwifsT+u6VHw@mail.gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Wed, 3 Apr 2013 01:29:06 +0200
Message-ID: <CAFWF=ak0uG-7_zka6WSSztRnVBESsnB+M+ia1fXi5Ncm3nGOQA@mail.gmail.com>
Subject: Re: Backup Options
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 2, 2013 at 7:37 PM, Harald Glatt <mail@hachre.de> wrote:
> Hi list,
>
> what are currently the backup options for btrfs?
>
> Is it possible to somehow duplicate the entire filesystem including
> all snapshots without using the real space for each snapshot onto a
> remote server? (Maybe given the remote server uses btrfs too?) Are
> these features planned?
>
> Right now the only solution I know of is dd if=eachDevice, netcat and
> xz or something combined. But that is not exactly a great solution.
>
> The other thing is rsyncing a single snapshot, but if I rsync several
> they occupy the full space on the remote machine each which is also
> less than optimal...
>
> Any other suggestions?
>
> Thanks!
> Harald

I was informed (via private mail) of the existance of btrfs send /
receive. I'm looking into that now to see how many of the things I'd
like to see are (or will be) covered by it!

Thanks
Harald
