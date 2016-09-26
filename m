Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36854 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754163AbcIZXya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 19:54:30 -0400
Received: by mail-io0-f176.google.com with SMTP id m79so72708ioo.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 16:54:30 -0700 (PDT)
MIME-Version: 1.0
From: Nate Hardt <nate.hardt@gmail.com>
Date: Mon, 26 Sep 2016 16:54:29 -0700
Message-ID: <CAHGx5GrdtiQaAs8pWsF6=A44ObZOMA0LbnhS8vuk-R6B+qWzuw@mail.gmail.com>
Subject: io_submit/read return value
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I am doing some testing on the btrfs shipped with RHEL 7.2 and have a
few questions.

1) It appears if I read from a hole in a file, or read a hole in a
partially allocated file, the return value for the read is the amount
of data actually read from disk, not the amount of data that is
written into the buffer I supply. I have a couple of tests that seem
to support this.

Reading from a thin provisioned file seems to return 0 and also fill
the buffer I supplied with 0s.

Writing say, a 4k block of 1s to the beginning and end of a file, then
supplying a memory buffer with the exact opposite, then doing the
read, fills the supplied buffer with the 1s I wrote, 0s for the hole
and the return value is 8k.

So first, I just wanted to verify that is expected and can be depended on.

2) In the event the underlying hard drive returns IO errors on read,
what is the expected behavior? Is the whole IO failed with a return
code of -1 and errno of EIO? Or if it reads some of the data before
hitting the IO error, is a partial read returned with the return code
the actual size of the data read? I have some data to indicate it is
not the former and I'm not sure what to do next if it is the latter.
For my use case I need to get EIO if there is any data BTRFS could not
get for me.

Thanks in advance if anyone is able to help. Having a fun time taking
btrfs for a spin and learning about how it works!

Nate
