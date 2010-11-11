From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: labelling
Date: 11 Nov 2010 11:53:00 +0100
Message-ID: <B$fKVvMD1uB@helmut.hullen.de>
References: <4CDBAB52.60903@jp.fujitsu.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDBAB52.60903@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Tsutomu,

Du meintest am 11.11.10:

>>>>          mount LABEL=MM2 /srv/MM
>>>>
>>>> doesn't work now, it tries to mount /dev/sdd2 and mourns.
>>>>
>>>>          mount /dev/sdd2 /srv/MM
>>>>
>>>> shows the same error message,


> I encountered the same problem, too.
> Please try 'btrfsctl -a' before mounting.

This command (or "/sbin/btrfs device scan 2>/dev/null") has to be put  
into the "init" procedure; it may be needed in runlevel 1 too, it may be  
needed if the root partition is a btrfs partition.

In my homemade slackware/sysv installation I have put this command into  
"/etc/init.d/boot", maybe for slackware it has to be put into "/etc/ 
rc.d/rc.S".

Viele Gruesse!
Helmut
