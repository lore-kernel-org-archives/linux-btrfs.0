Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaETKU0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 06:20:26 -0400
Date: Tue, 20 May 2014 12:20:24 +0200
From: Arvin Schnell <aschnell@suse.de>
To: "Dennis Lan (dlan)" <dennis.yxun@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: add arg_strtou64 break library btrfs
Message-ID: <20140520102024.GA12133@suse.de>
References: <CAF1ZMEfRCrnNU9HNUZwm2V154Z1f639m6ctFMKVbi3dRQw2cVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <CAF1ZMEfRCrnNU9HNUZwm2V154Z1f639m6ctFMKVbi3dRQw2cVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 06:15:49PM +0800, Dennis Lan (dlan) wrote:
> progs # cat btrfs_mini_tst.c
>  /*
>   * gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
>   */
> 
>   char btrfs_read_and_process_send_stream ();
>  int
>  main ()
>  {
>  return btrfs_read_and_process_send_stream ();
>  }
> 
> progs # gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
> /usr/lib/gcc/x86_64-pc-linux-gnu/4.8.2/../../../../lib64/libbtrfs.so:
> undefined reference to `arg_strtou64'
> collect2: error: ld returned 1 exit status

Hi,

that problem was already found. A fix can be found here:

http://www.spinics.net/lists/linux-btrfs/msg33434.html

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany
