From: "Ken D'Ambrosio" <ken@jots.org>
Subject: du reporting odd file sizes during copy.
Date: Wed, 6 Oct 2010 08:52:02 -0400 (EDT)
Message-ID: <23ef6090f815f34d606450a5a34f57a0.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all.  I was copying two 6-GB DVD images yesterday, and while
monitoring the copy progress, noticed that du would show a trend that
*generally* headed toward the final files' sizes, but on occasion would
hop backward, thusly:


root@hal-9000:/shared/ISOs# while true; do du * ; sleep 10; echo;done
1151808	SolidWorks_2008_32-bit.iso
1928784	SolidWorks_2008_64-bit.iso

1072032	SolidWorks_2008_32-bit.iso
1763280	SolidWorks_2008_64-bit.iso

1044384	SolidWorks_2008_32-bit.iso
2097152	SolidWorks_2008_64-bit.iso

1481248	SolidWorks_2008_32-bit.iso
2183184	SolidWorks_2008_64-bit.iso

The images did copy, but I'm just curious as to what the mechanics were
behind du's seemingly non-linear reporting.  (If it makes any difference,
one copy was coming in via an ssh pipe from a different machine; the other
was being copied from the local CD drive.  Both were using "cat" to write
the files.)

Thanks,

-Ken



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

