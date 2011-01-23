From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [regression?] hang with 2.6.37 on a BTRFS test machine
Date: 23 Jan 2011 15:13:00 +0100
Message-ID: <BePiAa4D1uB@helmut.hullen.de>
References: <201101231444.10680.Martin@lichtvoll.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101231444.10680.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Martin,

Du meintest am 23.01.11:

>> Maybe it's the same problem ... I have (among my machines) a
>> Thinkpad T22 on which I have run btrfs with kernel 2.6.37-rc4.
>> Sometimes it hung, too. But it's an old machine, with old RAM, with
>> some old disks.

> Is the hung comparable to what I have seen? I.e. mouse pointer and
> stuff still works, but when entering a command the shell does hang?

"What's a mouse pointer"?

I run this machine as a pure CLI machine.
If I remember correct the last crashes: nothing worked. No keyboard, no  
LAN connections. Only the "power down" button ...

> I will also continue to test with a 2.6.37 on a workstation at work,
> but there only some scratch partition uses BTRFS. My T23 has / and
> /home on it.

On my machines I've deleted btrfs for "working" directories, I'm only  
testing on devices with no valuable data. There's still a big problem  
with "ENOSPC".

Viele Gruesse!
Helmut
