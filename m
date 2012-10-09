Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61518 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JILiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 07:38:16 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3429195eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 04:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGy7Uti=kJKQ=Su1NqjOanQ+QCgsac=Au4HxibXgaa6j+as8NQ@mail.gmail.com>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
	<20121003115615.GB25498@carfax.org.uk>
	<CAGy7Uti=kJKQ=Su1NqjOanQ+QCgsac=Au4HxibXgaa6j+as8NQ@mail.gmail.com>
Date: Tue, 9 Oct 2012 13:38:14 +0200
Message-ID: <CAJHuE_BCt=tXuD7mjLh_JTe+FBq=n=7tEU+3X16tUpqcsw46uA@mail.gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Bart Noordervliet <bart@noordervliet.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Bart,

On Tue, Oct 9, 2012 at 11:43 AM, Bart Noordervliet
<bart@noordervliet.net> wrote:
> Hi Goffredo,
>
> thank you very much for your work on making the btrfs filesystem df
> output that much more understandable. It is a real improvement
> already. I would however like to bring this comment from Hugo to your
> attention once again:
>
> On Wed, Oct 3, 2012 at 1:56 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> $ ./btrfs filesystem df /
>>> Path: /
>>> Summary:
>>>   Disk_size:                 72.57GB
>>
>>    Also, use kB, MB, GB, TB for powers-of-ten based units, and KiB,
>> MiB, GiB, TiB for powers-of-two based units, please. I don't care
>> which you report in, but please do make the distinction. (And note
>> that it's kB with a lower case k, but KiB with an upper case K). This
>> brings us in line with the relevant ISO and IEEE standards.
>
> I strongly support this suggestion. With terabyte-disks being the norm
> and the difference between TB and TiB being 10%, we really can't
> afford ignoring the difference any longer. Contrary to Hugo, I also
> have a strong preference to change the calculations to use
> powers-of-ten. There is nothing binary about disk space; it's just a
> function of how many bits they reliably manage to cram onto a platter.
> And while the raw size of an SSD does tend to be binary, after
> reservation of the garbage-collection/spare area the effective size is
> also completely arbitrary. Any reference to powers-of-two is
> completely artificial in these areas. But if you don't want to change
> the calculation, please do change the units as Hugo requested.

I replayed in another email to Hugo about that. Basically I am not contrary
to the change, only it is unrelated to my patches. In may patches I use the
function pretty_sizes() which adds the suffix KB, MB, and this function was
here from 2008....

I am reviewing this function to change the suffix. However I noticed
that it needs
more work, because often the results are returned as:

> $ sudo btrfs fi show
> Label: 'antares-btrfs'  uuid: c0b83ac2-ded6-4b1a-a038-2d52ced11bba
>        Total devices 1 FS bytes used 20.60GB
>        devid    1 size 250.68GB used 39.79GB path /dev/vdb

Note " FS bytes used 20.60GB". To me the unit is or byte (the 2nd
word) or MB....

Regarding which unit we should use (MB or MiB), my feels is mixed. From one side
I am used to use the unit MiB, KiB; however from the other side the hard disks
are measured as GB and not GiB. For example an hard disk of 60GB
contains 60*10^9 bytes and not 60*2^30 bytes....

We could leave it configurable via a environmental variable. But this
could open
the door for a configuration file for the btrfs utility...


>
> Kind regards,
>
> Bart Noordervliet
