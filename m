Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 189-19-234-109.dsl.telesp.net.br ([189.19.234.109]:42409 "EHLO
	anthem.async.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbaLWUgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 15:36:07 -0500
Received: from localhost.localdomain (gasolinux.internal [192.168.99.14])
	by anthem.async.com.br (8.14.4/8.14.4/Debian-2ubuntu2.1) with ESMTP id sBNKa2mw012367
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 18:36:02 -0200
Date: Tue, 23 Dec 2014 18:36:02 -0200
From: Christian Robottom Reis <kiko@async.com.br>
To: linux-btrfs@vger.kernel.org
Subject: Re: Quota limit question
Message-ID: <20141223203601.GB30477@async.com.br>
References: <20141217011537.GA1114@anthem.async.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141217011537.GA1114@anthem.async.com.br>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2014 at 11:15:37PM -0200, Christian Robottom Reis wrote:
>     # btrfs qgroup limit 2000m 0/261 . && touch x
>     touch: cannot touch ‘x’: Disk quota exceeded
> 
> The strange thing is that it doesn't seem to be actually out of space:
> 
>     # btrfs qgroup show -p -r -e /var | grep 261
>     0/261    1111810048  391114752   2097152000  0          ---   

Replying to myself as I had not yet been subscribed in time to receive a
reply; I just upgraded to 3.18.1 and am seeing the same issue on the
same subvolume (and on no others).

    root@riff:/etc# uname -a
    Linux riff 3.18.1-031801-generic #201412170637 SMP Wed Dec 17 11:38:50
    UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

It's quite odd that this specific subvolume acts up, given that there
are quite a few others that are closer to the quota:

    subvol                  group        total       unshared
    -------------------------------------------------------------
    (unknown)               0/5      1.37G / none  1.16G /   none
    lxc-template1/rootfs    0/259    0.68G / none  0.10G /  2.00G
    machine-2/rootfs        0/261    1.07G / none  0.40G /  2.00G
    machine-3/rootfs        0/265    1.17G / none  0.41G /  2.00G
    lxc-template2/rootfs    0/271    0.77G / none  0.31G /  2.00G
    lxc-template3/rootfs    0/274    0.46G / none  0.02G /  2.00G
    machine-4/rootfs        0/283    7.12G / none  6.21G / 10.00G
    machine-5/rootfs        0/288    1.05G / none  0.34G /  2.00G
    machine-6/rootfs        0/289   11.33G / none 10.74G / 15.00G
    machine-7/rootfs        0/290    1.30G / none  0.68G /  2.00G
    machine-8/rootfs        0/292    1.00G / none  0.33G /  2.00G
    machine-9/rootfs        0/293    1.17G / none  0.38G /  2.00G
    machine-10/rootfs       0/306    1.34G / none  0.62G /  2.00G
    machine-11/rootfs       0/318    9.49G / none  8.75G / 15.00G
    lxc-template4/rootfs    0/320    0.79G / none  0.78G /  2.00G
    machine-14/rootfs       0/323    1.10G / none  0.45G /  2.00G

The LWN article suggests that btrfs is quite conservative with quotas,
but shouldn't 265, 290, 306, 320 and 323 all be out of quota as well? Or
is there a lot else that goes into the calculation beyond the numbers
reported by btrfs qgroup show?

What could I do to help investigate further?
-- 
Christian Robottom Reis | [+55 16] 3376 0125   | http://async.com.br/~kiko
CEO, Async Open Source  | [+55 16] 9 9112 6430 | http://launchpad.net/~kiko
