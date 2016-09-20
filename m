Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35855 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbcITIyY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:54:24 -0400
Received: by mail-lf0-f47.google.com with SMTP id g62so7469919lfe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 01:54:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA91j0X+6BZNyFrgoOhr86C0TiRPY40t6T1kQB8Jgk3hEBHjfw@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk> <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
 <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com> <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
 <CAA91j0X+6BZNyFrgoOhr86C0TiRPY40t6T1kQB8Jgk3hEBHjfw@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 20 Sep 2016 10:54:21 +0200
Message-ID: <CAEtw4r2nUHctUJNNn2VxZ3CLF-b+GYYjv6aPOEX6UHGqU=PmHw@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-09-20 10:30 GMT+02:00 Andrei Borzenkov <arvidjaar@gmail.com>:
> On Tue, Sep 20, 2016 at 11:20 AM, Peter Becker <floyd.net@gmail.com> wrote:
> I still do do understand where ENOSPC comes from in the first place.
> Filesystem is half empty. Do you suggest that it is normal to get
> ENOSPC in this case?

Its how the block allocator and the chunk allocator work together. As
i know the developer has this "bug" in there todo list.
