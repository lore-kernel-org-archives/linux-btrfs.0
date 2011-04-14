From: David Nicol <davidnicol@gmail.com>
Subject: completely revised ioctl for notification of when all space from a
 snapshot delete is freed and similar
Date: Thu, 14 Apr 2011 10:24:41 -0500
Message-ID: <BANLkTikCngouNYi33utswM+Ea6v_7e_jZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have started rewriting the ioctl#21 patch using a less hacky
architecture, including defining a new kind of structure that
explicitly organizes information common to delayed/deferred systems,
(the list of work pieces, and an atomic for counting active worker
threads) and replacing the lists of work pieces, in ioctl#21-tracked
deferred systems, with this structure instead.

I started march 25, but haven't had time to work on this since then
and would like to hand it off.

I have the structure as described above in place, and some macros for
use within the ioctl body written; the next thing is to try compiling
and replace all references to the replaced list heads with the new
syntax.

Any takers?


David Nicol
