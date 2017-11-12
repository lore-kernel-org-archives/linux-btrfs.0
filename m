Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:56950 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdKLASe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Nov 2017 19:18:34 -0500
Received: by mail-oi0-f46.google.com with SMTP id v9so9123270oif.13
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Nov 2017 16:18:34 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 11 Nov 2017 17:18:33 -0700
Message-ID: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
Subject: btrfs-image hash collision option, super slow
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK this might be in the stupid questions category, but I'm not
understanding the purpose of computing hash collisions with -ss. Or
more correctly, why it's taking so much longer than -s.

It seems like what we'd want is every filename to have the same hash,
but for the file to go through a PBKDF so the hashes we get aren't
(easily) brute forced. So I totally understand that -ss should take
much longer than -s, but this is at least two orders magnitude longer
(so far). That's why I'm confused.

-s option on this file system took 5 minutes, start to finish.
-ss option is at 8 hours and counting.

The other part I'm not groking is that some filenames fail with:

WARNING: cannot find a hash collision for 'Tool', generating garbage,
it won't match indexes

So? That seems like an undesirable outcome. And if it were just being
pushed through a PBKDF function, it wouldn't fail. Every
file/directory "Tool" would get the same hash on *this* run of
btrs-image. If I run it again, or someone else runs it, they'd get
some other hash (same hashes for each instance of "Tool" on their
filesystem).



-- 
Chris Murphy
