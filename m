From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Copy and remove performance impacted by COW reflink rewrite
Date: Tue, 28 Feb 2012 19:51:06 -0600
Message-ID: <CAB3q877vKuQZabp1Czcyb-cMfbqafbxmuy5_HCAU2XvtqPem=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I am running 3.2.7-1.fc16.x86_64 (latest FC 16 kernel)

I posted regarding this problem earlier, but after some research and
found improvement with new kernel version. so  I decided to repost in
a new thread to clean things up...

The intention of this post is to hopefully be useful and point out
some performance numbers that devs can use for testing and hopefully
get some tips to improve performance of cp and rm.

The test:
1. Create a 10GB file A
2. Make 40000 writes of a few bytes each.
3. Make a reflink of A as B.
4. Remove A
5. Iterate steps 2-4 and use new B as A for each iteration.

Ideally each iteration would take trivial time and run equally for
each test and no or little CPU would be used.
I observed increased CPU usage with each cp and rm after every iteration.

One of the users pointed out that SSD erase-blocks may have something
to do with the observation but I'm having difficulties taking this as
an answer because the numbers are repeatable with each re-run and SSD
has plenty of space. I wish I had a 16 GB RAM (probably will next
week) to make a ramdisk and to run a test on it.

Test can be found here:
http://pastebin.com/1gD0aZic
To run, make a directory on a btrfs filesystem with about 15G free
space at least, CD INTO IT (files will be created in pwd) and run
"bash <pastebin file> random". The output will be in random.csv

Graphs:
The X axis is thest iteration 1-20.
The Y axis on the left is time to cp/rm/sync and the RIGHT (blue) axis
are write times. There's a slight improvement for the initial writes,
but that's probably due to the original file having only one extent.

SSD: http://img7.imageshack.us/img7/3928/ssdac.png
(rw,relatime,ssd,nospace_cache)

HDD: http://img819.imageshack.us/img819/5595/hddw.png
(rw,relatime,nospace_cache)

HDD graph is posted as reference. The oscillation is expected due to
media fragmentation, but internal fragmentation trend follows the SSD
findings for a fw initial reqrites. The slow write times are expected
due to random writes causing a 10ms head delay (500 secs / 4000 ops ~=
 10ms for each write)

The SSD graph shows the actual problem better. The curves for rm, cp
and sync seem to follow the log(n) inherent design (B-tree search
complexty), but take too long in my opinion. I would like to get some
advice on how to improve these times and/or some analysis from a
developer.

I tried balance after the test and deleted the last remaining file
21.tst, but it would take it 1.5 MINUTES to run! My conclusion is that
it is broken. I also tried nodatacow and nodatasum and got no obvious
improvements. Defrag would return immediately and I could run it
during the test too without impacting the test numbers.

Thanks,
Nik Markovic
