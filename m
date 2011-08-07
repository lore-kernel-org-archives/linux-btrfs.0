From: Andrew Lutomirski <luto@mit.edu>
Subject: space cache generation (...) does not match inode (...)
Date: Sat, 6 Aug 2011 22:16:34 -0400
Message-ID: <CAObL_7Hc0AGOB8Jk-o_hseiqxEfDWFLSnMkhLLiu00GVbr729Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've always gotten space cache generation warnings, but some time
after 3.0 they started going nuts.  I get:

space cache generation (14667727114112179905) does not match inode (154185)

and other similar messages (with a huge number and a smaller number)
at rates higher than one message per ms.  They don't happen
constantly, but they come in bursts big enough to fill my log buffer.

--Andy
