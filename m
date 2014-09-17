Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbaIQRCB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 13:02:01 -0400
Message-ID: <5419BE75.5030107@redhat.com>
Date: Wed, 17 Sep 2014 12:01:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shilong Wang <wangshilong1991@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: "btrfs rescue super-recover" memory corruption
References: <5419BE1E.2020607@redhat.com>
In-Reply-To: <5419BE1E.2020607@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/17/14 12:00 PM, Eric Sandeen wrote:
> This:
> 
> # truncate --size=8g

oops, s/b:

# truncate --size=8g file

> # dd if=/dev/zero of=file conv=notrunc  bs=4 seek=16384 count=1
> # valgrind ./btrfs rescue super-recover file -v

