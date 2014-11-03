Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:60532 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbaKCDtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 22:49:07 -0500
Message-ID: <5456FB31.5030301@pobox.com>
Date: Sun, 02 Nov 2014 19:49:05 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tobias Holst <tobby@tobby.eu>
CC: Rich Freeman <r-btrfs@thefreemanclan.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com> <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com> <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com> <5455B7E7.3020404@pobox.com> <CAGwxe4i1=S-qgp91YjqH11juaGx6h0FyM7rDAWhFix+beCRgPw@mail.gmail.com>
In-Reply-To: <CAGwxe4i1=S-qgp91YjqH11juaGx6h0FyM7rDAWhFix+beCRgPw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2014 06:55 PM, Tobias Holst wrote:
> But I can't do a balance anymore?
>
> root@t-mon:~# btrfs balance start /dev/sda1
> ERROR: can't access '/dev/sda1'

Balance takes place on a mounted filesystem not a native block device.

So...

mount -t btrfs /dev/sda1 /some/path/somewhere
btrfs balance start /some/path/somewhere


