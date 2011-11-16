From: David Sterba <dave@jikos.cz>
Subject: Re: Segmentation Faults
Date: Thu, 17 Nov 2011 00:00:45 +0100
Message-ID: <20111116230045.GY12759@twin.jikos.cz>
References: <loom.20111116T171334-175@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tim Crone <tjcrone@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111116T171334-175@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Nov 16, 2011 at 04:39:21PM +0000, Tim Crone wrote:
> root@berna:~# uname -a
> Linux berna 2.6.38-bpo.2-amd64 #1 SMP Mon Jun 6 15:24:02 UTC 2011
> x86_64 GNU/Linux

2.6.38 is quite old from btrfs perspective and it's highly possible that
the bug you've hit is already fixed. Try newer (like 3.1) kernel and if
you still hit some sort of crash, please send the report.

> root@berna:/home/tjc# rm -rf .cache/chromium
> Segmentation fault
> root@berna:/home/tjc#
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877568] ------------[ cut here ]------------
> 
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877572] invalid opcode: 0000 [#1] SMP
> 
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877573] last sysfs file: /sys/devices/virtual/block/md0/uevent
> 
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877633] Stack:
> 
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877640] Call Trace:
> 
> Message from syslogd@localhost at Nov 16 11:19:35 ...
>  kernel:[   66.877703] Code: 24 24 48 8b 74 24 28 48 8d 54 24 50 41 b9 01 00 
> 00 00 48 89 d9 4c 89 e7 e8 80 6e ff ff 83 f8 00 41 89 c5 0f 8c c5 02 00 00 74
> 04 <0f> 0b eb fe 4c 8b 2b 8b 73 40 4c 89 ef e8 a3 e5 ff ff 41 89 c6

btw such output is printed to every console when the crash occurs, but
lacks important information like stacktrace and names of functions.
without that it's very hard to get a clue what happened.

> (I was going to include some log entries, but the lines are longer than
> 80 characters and your system will not accept them.)

As for stacktrace and line length, I personally want to see the lines
not wrapped at 80 (except the eg. byte dump of instructions), it helps
readability.


david
