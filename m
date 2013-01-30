Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52343 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3A3SWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:22:35 -0500
Received: by mail-wg0-f42.google.com with SMTP id 12so3113963wgh.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:22:34 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 30 Jan 2013 13:22:34 -0500
Message-ID: <CA+rwJ+a4id+yLhwoywq3tv3hV8TcVc9-mcozvZNscDx4udD_iQ@mail.gmail.com>
Subject: btrfs error -5
From: David Merris <me@davidmerris.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had an error the other day, and I either fail at Google, or Google
has nothing helpful to give me, so I thought I would ask here if
anyone had any information that will help me figure out what has gone
wrong and, hopefully, how to fix it. (Either a "go here and ask" or if
answers through here.) I am totally willing to live with "Well, you're
hosed, hope you had a backup!" (It was working on that, but hadn't
finished yet. That'll teach me to not keep a closer eye on the
device.)

The other day I noticed my CrashPlan clients could no longer backup to
my fileserver. I didn't think too much of it, and attempted to restart
CrashPlan. That spit out an error that I didn't think to write down,
but being that it uses Java, I shrugged it off, and asked the machine
to reboot. A bit later, I noticed that the machine still was not
responding, fired up the console in vSphere and saw the error:
btrfs: could not do orphan cleanup -5
btrfs: open_ctree failed

There are a few other errors about the parent transid verification
failing before those, and (since I didn't have copy/paste) I have
transcribed them at http://pastebin.com/6smrqPkP

I ran btrfsck on the device, and put the output of that at
http://pastebin.com/HcQxy6a1
I also ran btrfs-debug-tree on the device, but it created a 9.4 gig
file, so, I haven't tried to drop that on pastebin, but I can throw
them somewhere if someone would like to see them. (I'm hoping there is
some specific bit I can search for on my end and put that somewhere
helpful.)

Some information about my system:
Operating System: Ubuntu 12.04.1 LTS
Kernel: Linux 3.2.0-29-generic
btrfsck tells me it is "Btrfs Btrfs v0.19"
The filesystem is on a 10 disk raid 6 array that does not appear to be unhappy.
All of my btrfs tools came from Ubuntu's default repos.
The system is a virtual machine running under a VMware ESXi 5.0.0
host, with the 10 drives passed through to the guest OS. I have
allocated 8GB of memory to the guest.
