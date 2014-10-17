Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51465 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaJQTYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 15:24:42 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so1605516wgh.24
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 12:24:40 -0700 (PDT)
Received: from localhost (host86-171-140-171.range86-171.btcentralplus.com. [86.171.140.171])
        by mx.google.com with ESMTPSA id ew4sm520738wid.19.2014.10.17.12.24.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 17 Oct 2014 12:24:39 -0700 (PDT)
Date: Fri, 17 Oct 2014 20:24:38 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ccache on btrfs
Message-ID: <20141017192438.GA20983@sune>
References: <2700CF0B-F340-44F7-A4D6-0C5FF05CCD81@gmail.com>
 <CAGqmi7751HOLJ5xU+NfoZSjTQhgYME-9b36hgJt0oG6w+Ft-CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi7751HOLJ5xU+NfoZSjTQhgYME-9b36hgJt0oG6w+Ft-CA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/10/14, Timofey Titovets wrote:
> i use ccache and often compile linux from git,
> I don't catch any errors with it.
> 
Interesting, I re-enabled ccache on an ext4 partition (HDD) and worked
fine. So I suspect it's something to do with btrfs and SSD. My mount
options are:
/dev/sda3 on /home type btrfs (rw,relatime,ssd,discard,nospace_cache)

The problem is that I can't get hold of kernel panic since it's not in
the journal [1]. I don't know a way to get hold of the kernel panic log
to help anyway.

What would it be useful to debug it?

[1] using systemd

Leonidas
