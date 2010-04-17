From: manio <manio@skyboo.net>
Subject: Re: NFS mount attempts hangs with btrfs on server side
Date: Sat, 17 Apr 2010 22:10:15 +0200
Message-ID: <4BCA15A7.9000502@skyboo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 > Greetings.
 >
 > I am observing a case whereby NFS mounting seems to hang. A tcpdump
 > trace reveals that it retries forever RPC and exchanging NFS messages
 > without giving any warning or error message about what's wrong. There is
 > no firewall active, and the NFSserver (.1) has the client (.101)
 > unconditionally allowed.
 >
 > It's a simple
 > mount -t nfs 192.168.100.1:/B/home/jengelh /home/jengelh -o tcp,intr,soft
 >
 > /B is a btrfs volume. Mounting an ext4 volume over NFS instead completes
 > in a splitsecond.
 >
 > Attached is the pcap file (->wireshark pretty display for deciphering).
 >
 > It seems pretty much independent of the Linux kernel used; I can
 > reproduce this in both 2.6.33-rc8 as well as 2.6.31.12.

Hello
I have very similar behavior. On the server side i have nfs kernel server
(nfs version 3) - when mounting ext3 directories - all works fine,
but when i export btrfs directory and try to mount it:
on client side (debian sid) i've got:
mount.nfs: Connection timed out
and during mounting time on server side (debian lenny):
about 20 lines with: "authenticated mount request ..."

i also tryed it on another client with debian lenny and first mount try
was about several seconds long and results in:
mount.nfs: Stale NFS file handle
next tryes results with same error, but it was very fast responses
to the mount command

after several mount tryes i always have a problem with restarting
nfs-kernel-server with debian init script:

Stopping NFS kernel daemon: mountd nfsd.
Unexporting directories for NFS kernel daemon....
Exporting directories for NFS kernel daemon....
Starting NFS kernel daemon: nfsd <--- hungs here
... and the only way to bring the nfs server back online
was to reboot the server :(

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
