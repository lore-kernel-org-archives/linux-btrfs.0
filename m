Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:54153 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbcCKDzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 22:55:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 11 Mar 2016 12:55:20 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Cc: tobias.hunger@gmail.com
Subject: Re: btrfs and containers
Message-ID: <4d5d1ffec6db0dc343b0d143172bcbd6@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have been running systemd-nspawn containers on top of a btrfs
> filesystem for a while now.
> 
> This works great: Snapshots are a huge help to manage containers!
> 
> But today I ran btrfs subvol list . *inside* a container. To my
> surprise I got a list of *all* subvolumes on that drive. That is
> basically a complete list of containers running on the machine. I do
> not want to have that kind of information exposed to my containers.

You seem to be running a privileged container, i.e. container's root is 
the same UID as host root. This is typically undesired and means that 
your containers have full access to data on host and on other 
containers.

For the record, with a privileged container you can not only list the 
subvolumes, but also list disk data (i.e. dd if=/dev/sda) or even 
destroy that data (dd if=/dev/zero of = / dev / sda).

So, think twice if the container setup you have is what you want!

LXD is particularly easy to run unprivileged containers: 
https://linuxcontainers.org/ (starts containers as unprivileged by 
default, and has lots of many goodies in general).


Tomasz Chmielewski
http://wpkg.org


