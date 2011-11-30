From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Resize command syntax wrong?
Date: 30 Nov 2011 19:59:00 +0100
Message-ID: <ByrPr1UD1uB@helmut.hullen.de>
References: <4ED67A2E.9080809@cfl.rr.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED67A2E.9080809@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Phillip,

Du meintest am 30.11.11:

> Currently the resize command is under filesystem, and takes a path to
> the mounted filesystem.  This seems wrong to me.  Shouldn't it be
> under device, and take a path to a device to resize?

No - it's a filesystem operation.

p.e.
You start with a system of 2 disks. They get filled nearly  
simultaneously.
Then you add a 3rd disk (which is empty at that time). Now it's a good  
idea to run "balance" for equalizing the filling.


Viele Gruesse!
Helmut
