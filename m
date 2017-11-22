Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:37733 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdKVQmG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 11:42:06 -0500
Received: by mail-ot0-f177.google.com with SMTP id s4so14075861ote.4
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 08:42:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
 <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
 <1c612777-77eb-1b83-101b-a9e0a53ee8be@gmail.com> <CAJCQCtRwO5E_xN-7u22uBQ57sYpUf8qQ7O0Abz2m+K8e9+DgdA@mail.gmail.com>
 <384b4a21-e74f-c52e-c6e2-f7930f187c94@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Nov 2017 09:42:05 -0700
Message-ID: <CAJCQCtQKOVYtOmQeCR0GZ08Wew2TjtZzfoA_mDvsHwL5vt06XA@mail.gmail.com>
Subject: Re: uncorrectable errors in Raid 10
To: Steffen Sindzinski <stesind@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 9:38 AM, Steffen Sindzinski <stesind@gmail.com> wrote:
> Hello,
>
> I did btrfs check --readonly on both disk without finding any error. To
> reconfirm I did a scrub again which still has found 2 uncorrectable errors.

Try --mode=lowmem option with btrfs-progs 4.3.3 or better 4.14. This
is a new implementation of btrfs check and sometimes it comes up with
different results. It's strange that there's only this error found by
scrub and not by btrfs check which should be fully checking all
metadata for sanity, and in the process it would surely hit a bad
checksum.


-- 
Chris Murphy
