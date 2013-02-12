Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:35800 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3BLVm2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 16:42:28 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D85A37C0416
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 14:42:27 -0700 (MST)
Date: Tue, 12 Feb 2013 16:42:25 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130212214225.GM16687@shiny.masoncoding.com>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
 <20130212191637.GD2611@localhost.localdomain>
 <20130212210535.GC16773@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iAL9S67WQOXgEPD9"
In-Reply-To: <20130212210535.GC16773@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--iAL9S67WQOXgEPD9
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Feb 12, 2013 at 02:05:35PM -0700, Richard W.M. Jones wrote:
> 
> Yes, this is inside a very recent KVM (qemu 1.3.0), using virtio-scsi
> as the backing disk.

Ok, can you please run this on your virtio device file?  It will
overwrite the first 256K, so don't do this on a file you care about.

gcc -Wall -o vtest vtest.c

./vtest /dev/xxx

I've attached vtest.c and gzip'd it just to make sure no mailers mess
with my pretty code.

-chris

--iAL9S67WQOXgEPD9
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="vtest.c.gz"
Content-Transfer-Encoding: base64

H4sICFu2GlEAA3Z0ZXN0LmMA3VTva9swEP1s/xW3li5O6m1KyQqjP2C0LpQNBklgsK4YxT61
Yo5kbCVtt+V/30m2kzoJW+jHfTDIp3vvnZ5Oty9Vks1ShNPyqXxnnnIs396f+/utcGm4aUdF
okzWDs2ULE26Bjap1BuhTE7WY4VUd5u6Rk7RRv39FIVUCFfXn6N4dP0tguDo/TH0oM+OBt3l
9pf48noYXYw9xtiAPub7tnSZwFzLFB4KaTDWCuPJTARSGRBpCDNVyjuFKST3vIAebXX9X75X
lvInxgYKNCe+l2kh6CfXJZwBo4BFZygM/S6LOvF9j9IplJWIPwLLzkIYRdGneBSNuxYmILAp
p8C6QCpejkWhi2DPIfZsioeP0gR9u1wQ4cO9zBACp3XeoCoVdx6nQkXDoa0udEU5mqXUWYNa
ijlgJfZMjeQohU54eFaf2nOqb5rfhb9oG1ogT/8jP+1xXmKnxb3QTXvsKZfKuceTsDatx+fO
tE0va6sqispyWlTbgk6m+BRXvpG+fIynOOUZ8QSBu7Ver/uamEIYsA/H4cruZ362vUy4UprK
yzKdcINAfLp4+q622WsJeELO9iuOpiYqhs9v+rcWIXJ67kYENApIIQTXjzQAwGg4KIk3hAbm
aAHpNiu2dWSeIae9vNBzSVODL4HbqxMp1aFzVEGTF9LQGF5+HcJvWlwMo49jt6rmCLXbMWON
LwTeaDPL9Zcuq00gw0o0gTO9wztrnnvtuVQ3YNfeokeLG3ZLRXcmnZ1Tk91T091TcfdU8a/U
1uBY7VSvrOZ55Yjqp7Zx8RNejR9qFT1TKRwkrm8q7La3uKgexaxQdt4s/D/L1HUb+QYAAA==

--iAL9S67WQOXgEPD9--
