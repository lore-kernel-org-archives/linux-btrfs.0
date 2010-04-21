From: Manio <manio@skyboo.net>
Subject: Re: NFS mount attempts hangs with btrfs on server side
Date: Wed, 21 Apr 2010 12:25:15 +0200
Message-ID: <4BCED28B.5040806@skyboo.net>
References: <4BCA15A7.9000502@skyboo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BCA15A7.9000502@skyboo.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-04-17 22:10, manio wrote:
> > Greetings.
> >
> > I am observing a case whereby NFS mounting seems to hang. A tcpdump
> > trace reveals that it retries forever RPC and exchanging NFS messages
> > without giving any warning or error message about what's wrong. 
> There is
> > no firewall active, and the NFSserver (.1) has the client (.101)
> > unconditionally allowed.
> >
> > It's a simple
> > mount -t nfs 192.168.100.1:/B/home/jengelh /home/jengelh -o 
> tcp,intr,soft
> >
> > /B is a btrfs volume. Mounting an ext4 volume over NFS instead 
> completes
> > in a splitsecond.
>
> Hello
> I have very similar behavior. On the server side i have nfs kernel server
> (nfs version 3) - when mounting ext3 directories - all works fine,
> but when i export btrfs directory and try to mount it:
> on client side (debian sid) i've got:
> mount.nfs: Connection timed out
> and during mounting time on server side (debian lenny):
> about 20 lines with: "authenticated mount request ..."
>

Hello
Now i can reply myself - i hope it could be helpful to someone :)
The problem was: old nfs-utils and/or userland (portmap and stuff
like that). First i was trying to repeat mounting on debian sid
and it works - so i finally decided to bring up my debian stable
to squeeze - and it is working now!! :)

i am using linux-2.6.34-rc4 btw.

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
