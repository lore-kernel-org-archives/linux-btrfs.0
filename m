From: Christian Brunner <chb@muc.de>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Sat, 26 Nov 2011 22:21:04 +0100
Message-ID: <CAO47_--zte=M1Yffsii8TmvB1GLahMM5BLU5b7qGH7P=W3W_3g@mail.gmail.com>
References: <4EBA54F2.3030801@unilogicnetworks.net>
	<20111109153552.GB1810@localhost.localdomain>
	<4EBBBFFA.5090000@unilogicnetworks.net>
	<20111114160342.GB1947@localhost.localdomain>
	<4EC2B9E7.7020609@unilogicnetworks.net>
	<20111115192926.GB1944@localhost.localdomain>
	<4EC2C940.40605@unilogicnetworks.net>
	<20111118195226.GB1811@localhost.localdomain>
	<4ED0F44D.3070001@unilogicnetworks.net>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED0F44D.3070001@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/26 Stefan Kleijkers <stefan@unilogicnetworks.net>:
> Hello Josef,
>
> I've new results, is this the trace you are looking for?
>
> Trace of OSD0: http://pastebin.com/gddLBXE4
> Dmesg of OSD0: http://pastebin.com/Uebzgkjv
>
> OSD1 crashed a while later with the same messages.
>
> Stefan

Hi Josef,

I ran your patch on one of our ceph nodes, too. At the first run it
hit the BUG_ON and creashed. Unfortunately I was not able to get the
trace messages from the server (I'm glad that Stefan managed to fetch
it), so I gave it a second spin. This time it did NOT hit the BUG_ON,
but I wrote the trace to a file, so I can send you the trace output at
that time. You can find dmesg-output here:

http://pastebin.com/pWWsZ79e

The trace messages from 154900 till 154999 are here (don't know if
this is interesting):

http://pastebin.com/01EKHqn5

and the tracing output from 206200 till 206399 is here:

http://pastebin.com/50PNtiF7

I hope, that this will give you a better insight into this. I will now
reboot and run it a third time, to see if I can hit the BUG_ON again.

Regards,
Christian
