Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49750 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2JIJne (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 05:43:34 -0400
Received: by mail-wg0-f42.google.com with SMTP id fm10so2586195wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 02:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121003115615.GB25498@carfax.org.uk>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003115615.GB25498@carfax.org.uk>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Tue, 9 Oct 2012 11:43:12 +0200
Message-ID: <CAGy7Uti=kJKQ=Su1NqjOanQ+QCgsac=Au4HxibXgaa6j+as8NQ@mail.gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

thank you very much for your work on making the btrfs filesystem df
output that much more understandable. It is a real improvement
already. I would however like to bring this comment from Hugo to your
attention once again:

On Wed, Oct 3, 2012 at 1:56 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> $ ./btrfs filesystem df /
>> Path: /
>> Summary:
>>   Disk_size:                 72.57GB
>
>    Also, use kB, MB, GB, TB for powers-of-ten based units, and KiB,
> MiB, GiB, TiB for powers-of-two based units, please. I don't care
> which you report in, but please do make the distinction. (And note
> that it's kB with a lower case k, but KiB with an upper case K). This
> brings us in line with the relevant ISO and IEEE standards.

I strongly support this suggestion. With terabyte-disks being the norm
and the difference between TB and TiB being 10%, we really can't
afford ignoring the difference any longer. Contrary to Hugo, I also
have a strong preference to change the calculations to use
powers-of-ten. There is nothing binary about disk space; it's just a
function of how many bits they reliably manage to cram onto a platter.
And while the raw size of an SSD does tend to be binary, after
reservation of the garbage-collection/spare area the effective size is
also completely arbitrary. Any reference to powers-of-two is
completely artificial in these areas. But if you don't want to change
the calculation, please do change the units as Hugo requested.

Kind regards,

Bart Noordervliet
