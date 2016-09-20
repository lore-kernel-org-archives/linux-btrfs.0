Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:34491 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcITIap (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:30:45 -0400
Received: by mail-qt0-f177.google.com with SMTP id 38so4172279qte.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 01:30:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk> <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
 <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com> <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 20 Sep 2016 11:30:44 +0300
Message-ID: <CAA91j0X+6BZNyFrgoOhr86C0TiRPY40t6T1kQB8Jgk3hEBHjfw@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Peter Becker <floyd.net@gmail.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 11:20 AM, Peter Becker <floyd.net@gmail.com> wrote:
> The last option completly avoid the ENOSPC issue but produce aditional
> workload for your harddrives.
>

I still do do understand where ENOSPC comes from in the first place.
Filesystem is half empty. Do you suggest that it is normal to get
ENOSPC in this case?
