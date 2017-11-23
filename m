Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:41003 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdKWMCe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 07:02:34 -0500
Received: by mail-wm0-f44.google.com with SMTP id b189so16343308wmd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 04:02:33 -0800 (PST)
Subject: Re: uncorrectable errors in Raid 10
To: Chris Murphy <lists@colorremedies.com>, quwenruo.btrfs@gmx.com
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com>
 <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
 <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Steffen Sindzinski <stesind@gmail.com>
Message-ID: <63eff0dd-050c-95e5-0bc8-6c151900261c@gmail.com>
Date: Thu, 23 Nov 2017 13:02:31 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I updated to btrfs-progs v4.14-5-gf09e98a3. Unfortunately after 10h 
Gnome desktop / Arch crashed with btrfs check --lowmem unfinished. I 
will run it this night again.

The result until crash was:

Checking filesystem on /dev/sdd2
UUID: 4fafd0d4-7dd9-4dcc-9a33-5f1ad9555358
ERROR: extent[15923092037632, 73728] referencer count mismatch (root: 
260, owner: 3631467, offset: 1019904) wanted: 4, have: 6
ERROR: extent[16078964924416, 69632] referencer count mismatch (root: 
260, owner: 4086589, offset: 4296704) wanted: 5, have: 7

Steffen


Am 22.11.2017 um 17:42 schrieb Chris Murphy:
> On Wed, Nov 22, 2017 at 9:38 AM, Steffen Sindzinski <stesind@gmail.com> wrote:
>> Hello,
>>
>> I did btrfs check --readonly on both disk without finding any error. To
>> reconfirm I did a scrub again which still has found 2 uncorrectable errors.
> 
> Try --mode=lowmem option with btrfs-progs 4.3.3 or better 4.14. This
> is a new implementation of btrfs check and sometimes it comes up with
> different results. It's strange that there's only this error found by
> scrub and not by btrfs check which should be fully checking all
> metadata for sanity, and in the process it would surely hit a bad
> checksum.
> 
> 
