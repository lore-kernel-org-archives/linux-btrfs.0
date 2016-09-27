Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36641 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbcI0C1T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 22:27:19 -0400
Received: by mail-oi0-f44.google.com with SMTP id t83so433740oie.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 19:27:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160927071656.51ef5ef0@natsu>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
 <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com> <20160927071656.51ef5ef0@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 26 Sep 2016 20:27:18 -0600
Message-ID: <CAJCQCtQbP7NYyVdNEPpwXLJNMiQPZ4HWb0hNzLT0MVuBJ4RMTw@mail.gmail.com>
Subject: Re: OS X Time Machine and BTRFS
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 8:16 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Mon, 26 Sep 2016 15:06:39 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
>
>> First question is if the directory containing the sparsebundle file
>> has xattr +C set on it?
>
> It's not xattr, but chattr. "xattr" manages "extended attributes", i.e.
> arbitrary name=value pairs you can set on a file or directory. But +C is just
> one of the standard ones.

I'm using xattr as a contraction for extended attribute, I don't have
an xattr command on my Fedora system. But macOS does have an xattr
command so I can see how that might be confusing.


-- 
Chris Murphy
