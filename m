Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33823 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdEDL0V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 07:26:21 -0400
Received: by mail-qk0-f180.google.com with SMTP id k74so7870127qke.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 May 2017 04:26:21 -0700 (PDT)
Received: from tleilax.poochiereds.net ([2606:a000:1128:8294:dc89:2c19:2b17:eaaa])
        by smtp.gmail.com with ESMTPSA id t23sm1296075qka.37.2017.05.04.04.26.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 May 2017 04:26:19 -0700 (PDT)
Message-ID: <1493897177.2783.4.camel@redhat.com>
Subject: help converting btrfs to new writeback error tracking?
From: Jeff Layton <jlayton@redhat.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 04 May 2017 07:26:17 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been working on set of patches to clean up how writeback errors are
tracked and handled in the kernel:

http://marc.info/?l=linux-fsdevel&m=149304074111261&w=2

The basic idea is that rather than having a set of flags that are
cleared whenever they are checked, we have a sequence counter and error
that are tracked on a per-mapping basis, and can then use that sequence
counter to tell whether the error should be reported.

This changes the way that things like filemap_write_and_wait work.
Rather than having to ensure that AS_EIO/AS_ENOSPC are not cleared
inappropriately (and thus losing errors that should be reported), you
can now tell whether there has been a writeback error since a certain
point in time, irrespective of whether anyone else is checking for
errors.

I've been doing some conversions of the existing code to the new scheme,
but btrfs has _really_ complicated error handling. I think it could
probably be simplified with this new scheme, but I could use some help
here.

What I think we probably want to do is to sample the error sequence in
the mapping at well-defined points in time (probably when starting a
transaction?) and then use that to determine whether writeback errors
have occurred since then. Is there anyone in the btrfs community who
could help me here?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
