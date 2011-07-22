From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: Re: Issues with KVM
Date: Fri, 22 Jul 2011 23:03:43 +0200
Message-ID: <31d58f70e3887e23ad38664e29dda5ee@imt-systems.com>
References: <4E29D318.7050602@haypocalc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Victor Stinner <victor.stinner@haypocalc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E29D318.7050602@haypocalc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 22 Jul 2011 21:44:24 +0200, Victor Stinner wrote:
> Should I try other KVM option (e.g. use another type of image)? Try
> btrfs RAID instead of Linux MD RAID? Try to disable some CPU cores? 
> Or
> maybe not using btrfs for KVM images? :-)

Hi,

I would suggest you the following points:

- qemu-img create -f qcow2 -o size=40000000000,preallocation=metadata 
vdisk.img
- disk: cache=none
- controller: virtio

Best regards,

Morten
