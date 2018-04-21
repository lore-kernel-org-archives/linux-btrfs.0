Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.169.139]:57994 "EHLO
        mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbeDUQSP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 12:18:15 -0400
Subject: Re: extent-tree.c no space left (4.9.77 + 4.16.2)
To: Martin Svec <martin.svec@zoner.cz>
Cc: linux-btrfs@vger.kernel.org
References: <74c299a0-913b-d6ed-466b-59d83103eead@codepoets.co.uk>
 <bc39e325-7c7b-dd00-78bd-483c5393cd64@zoner.cz>
From: David Goodwin <david@codepoets.co.uk>
Message-ID: <53794a82-0c35-c35a-a261-60e9033d1c0a@codepoets.co.uk>
Date: Sat, 21 Apr 2018 17:18:04 +0100
MIME-Version: 1.0
In-Reply-To: <bc39e325-7c7b-dd00-78bd-483c5393cd64@zoner.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 21/04/2018 10:18, Martin Svec wrote:
> Hi David,
>
> this looks like the bug that I already reported two times:
>
> https://www.spinics.net/lists/linux-btrfs/msg54394.html
> https://www.spinics.net/lists/linux-btrfs/msg75104.html
>
> The second thread contains Nikolay's debug patch that can confirm if you run out of global metadata
> reservations too.

Thanks. I'm also rsync'ing to the volume (--inplace).


David.
